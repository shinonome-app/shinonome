# frozen_string_literal: true

module TailwindHelper
  # rubocop:disable Layout/LineLength
  def delete_button_class
    'grid w-full bg-ab_alert border-2 border-white hover:bg-ab_alert hover:border-2 hover:border-white hover:shadow-[0px_2px_18px_0px_#fed7e2] active:bg-ab_alert focus-visible:ring ring-gray-300 text-white text-base font-semibold text-center rounded-lg outline-none transition duration-100 px-8 py-3 mb-2 cursor-pointer'
  end

  def input_form_class
    'text-gray-600 w-full border border-ab_form focus:outline-none focus:border-ab_focus focus:ring-1 focus:ring-ab_focus focus:shadow-[0px_1px_13px_0px_#bee3f8] invalid:border-pink-500 invalid:text-pink-600 rounded outline-none transition duration-100 px-2 py-2'
  end

  def textarea_form_class
    'w-full border border-ab_form focus:outline-none focus:border-ab_focus focus:ring-1 focus:ring-ab_focus focus:shadow-[0px_1px_13px_0px_#bee3f8] invalid:border-pink-500 invalid:text-pink-600 rounded outline-none transition duration-100 px-2 py-2'
  end

  def select_form_class
    "w-full min-w-[100px] bg-[url('/images/svg/dropdown.svg')] bg-no-repeat bg-[right_0.8rem_center] rounded px-2 py-2 border border-ab_form focus:outline-none focus:border-ab_focus focus:ring-1 focus:ring-ab_focus focus:shadow-[0px_1px_13px_0px_#bee3f8] cursor-pointer appearance-none"
  end

  def primary_button_class
    'grid w-full bg-ab_primary border-2 border-white hover:bg-ab_primary_hover hover:border-2 hover:border-white hover:shadow-[0px_2px_18px_0px_#ebf8ff] active:bg-ab_primary_hover focus-visible:ring ring-gray-300 text-white text-base font-semibold text-center rounded-lg outline-none transition duration-100 px-8 py-3 mb-2 cursor-pointer'
  end

  def secondary_button_class
    'grid w-full bg-white border-2 border-gray hover:bg-white hover:border-2 hover:border-gray hover:shadow-[0px_2px_18px_0px_#edf2f7] active:bg-white focus-visible:ring ring-gray-300 text-zinc-700 text-base font-semibold text-center rounded-lg outline-none transition duration-100 px-8 py-3 mb-2 cursor-pointer'
  end
  # rubocop:enable Layout/LineLength
end
