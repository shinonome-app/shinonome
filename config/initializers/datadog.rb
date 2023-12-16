Datadog.configure do |c|
  c.env = Rails.env
  c.service = 'shinonome'
  c.agent.host = '172.17.0.1' # deafult host IP
  c.agent.port = 8126
  c.tracing.enabled = Rails.env.production?
  c.tracing.log_injection = false
  c.tracing.analytics.enabled = true
  c.tracing.instrument :rails, service_name: 'shinonome'
end
