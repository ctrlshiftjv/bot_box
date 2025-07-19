
require 'logger'

require 'bot_box/config'

module BotBox
  module Logger

    def self.logger
      @logger ||= ::Logger.new($stdout).tap do |log|
        log.level = ::Logger::UNKNOWN
        log.progname = BotBox::NAME
        log.formatter = proc do |severity, datetime, progname, msg|
          "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{progname} #{severity}: #{msg}\n"
        end
      end
    end
  
    # Shortcuts for convenience
    def self.info(msg) = logger.info(msg)
    def self.warn(msg) = logger.warn(msg)
    def self.error(msg) = logger.error(msg)
    def self.debug(msg) = logger.debug(msg)

  end
end
