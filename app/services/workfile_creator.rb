# frozen_string_literal: true

# Workfileの作成・更新・削除を管理するサービスクラス
# ファイル操作とモデル操作を一元管理し、コントローラをスリム化する
class WorkfileCreator
  # Workfileを新規作成
  def create(workfile_params, uploaded_file)
    return Result.failure(nil, 'ファイルが選択されていません', :no_file) unless uploaded_file

    workfile = Workfile.new(workfile_params)
    workfile.filename = uploaded_file.original_filename

    return Result.failure(workfile, 'バリデーションエラー', :validation_error) unless workfile.save

    begin
      save_file_and_convert(workfile, uploaded_file)
      Result.success(workfile, 'ワークファイルが正常に作成されました。')
    rescue StandardError => e
      cleanup_on_error(workfile)
      Result.failure(workfile, "ファイル保存に失敗しました: #{e.message}", :file_save_error)
    end
  end

  # Workfileを更新
  def update(workfile, workfile_params, uploaded_file)
    if uploaded_file
      update_with_file(workfile, workfile_params, uploaded_file)
    else
      update_metadata_only(workfile, workfile_params)
    end
  end

  # Workfileを削除
  def destroy(workfile)
    workfile.filesystem.delete
    workfile.destroy!
    Result.success(workfile, '削除しました.')
  rescue StandardError => e
    Result.failure(workfile, "削除に失敗しました: #{e.message}", :delete_error)
  end

  private

  # ファイル付きでの更新
  def update_with_file(workfile, workfile_params, uploaded_file)
    backup_path = create_backup(workfile)

    begin
      # ファイル名更新
      workfile.filename = uploaded_file.original_filename if uploaded_file.original_filename.present?

      # ファイル保存と変換
      save_file_and_convert(workfile, uploaded_file)

      # メタデータ更新
      if workfile.update(workfile_params)
        cleanup_backup(backup_path)
        Result.success(workfile, 'ワークファイルが正常に更新されました。')
      else
        restore_from_backup(workfile, backup_path)
        Result.failure(workfile, 'バリデーションエラー', :validation_error)
      end
    rescue StandardError => e
      restore_from_backup(workfile, backup_path)
      Result.failure(workfile, "ファイル更新に失敗しました: #{e.message}", :file_update_error)
    end
  end

  # メタデータのみの更新
  def update_metadata_only(workfile, workfile_params)
    if workfile.update(workfile_params)
      Result.success(workfile, 'ワークファイルが正常に更新されました。')
    else
      Result.failure(workfile, 'バリデーションエラー', :validation_error)
    end
  end

  # ファイル保存と変換処理
  def save_file_and_convert(workfile, uploaded_file)
    workfile.filesystem.save(uploaded_file)

    return unless needs_conversion?(workfile)

    result = WorkfileConverter.new.convert_format(workfile)
    return if result.converted?

    workfile.filesystem.delete
    raise StandardError, 'ファイル変換に失敗しました'
  end

  # 変換が必要かチェック
  def needs_conversion?(workfile)
    workfile.filename&.end_with?('.txt')
  end

  # エラー時のクリーンアップ
  def cleanup_on_error(workfile)
    workfile.filesystem.delete if workfile.filesystem&.exists?
    workfile.destroy if workfile.persisted?
  end

  # バックアップファイル作成
  def create_backup(workfile)
    return nil unless workfile.filesystem.exists?

    backup_path = "#{workfile.filesystem.path}.backup"
    FileUtils.cp(workfile.filesystem.path, backup_path)
    backup_path
  end

  # バックアップから復元
  def restore_from_backup(workfile, backup_path)
    return unless backup_path && File.exist?(backup_path)

    FileUtils.mv(backup_path, workfile.filesystem.path)
  end

  # バックアップファイル削除
  def cleanup_backup(backup_path)
    FileUtils.rm_f(backup_path) if backup_path
  end

  # 結果返却用クラス
  class Result
    attr_reader :workfile, :message, :error_type

    def initialize(success:, workfile:, message:, error_type: nil)
      @success = success
      @workfile = workfile
      @message = message
      @error_type = error_type
    end

    # 成功時の結果オブジェクトを作成
    def self.success(workfile, message)
      new(success: true, workfile: workfile, message: message)
    end

    # 失敗時の結果オブジェクトを作成
    def self.failure(workfile, message, error_type)
      new(success: false, workfile: workfile, message: message, error_type: error_type)
    end

    def success?
      @success
    end

    def failure?
      !@success
    end

    # バリデーションエラーかどうか
    def validation_error?
      @error_type == :validation_error
    end

    # ファイルなしエラーかどうか
    def no_file_error?
      @error_type == :no_file
    end
  end
end
