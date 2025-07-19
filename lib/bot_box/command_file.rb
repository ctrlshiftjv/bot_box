# frozen_string_literal: true

require "bot_box/config"

module BotBox

  # CommandFile is a class that parses the command file and returns a list of commands.
  #
  # WARNING: 
  #   - If the command file is NOT passed in, an ArgumentError will be raised.
  #   - If the command file is not found, an ArgumentError will be raised.
  #   - If the command file is not a plain text file, an ArgumentError will be raised.
  #   - If the command file is too large, an ArgumentError will be raised.
  class CommandFile

    attr_reader :command_file, :commands

    def initialize(command_file)
      @command_file = command_file
      @commands = parsed_instructions
    end

    private

    # Parse the command file and return a list of commands.
    def parsed_instructions
      validate_command_file

      commands = []
      
      File.foreach(command_file) do |command_line|
        command_line = command_line.strip
        
        # Skip empty lines
        next if command_line.empty?
        commands << command_line
      end

      BotBox.logger.info "Successfully parsed #{commands.length} commands from #{command_file}"

      return commands
    end

    # Validate the command file before processing
    def validate_command_file
      raise ArgumentError, "Command file is required" if command_file.nil?
      raise ArgumentError, "Command file does not exist" unless File.exist?(command_file)
      raise ArgumentError, "Command file is not readable" unless File.readable?(command_file)
      raise ArgumentError, "Command file type is not valid" unless file_without_extension?(command_file)
      raise ArgumentError, "Command file size is too large" if File.size(command_file) > MAX_FILE_SIZE
      raise ArgumentError, "Command file must be a plain text file" unless is_plain_text?(command_file)
    end

    def file_without_extension?(command_file)
      filename = File.basename(command_file)
      !filename.include?('.')
    end

    def is_plain_text?(command_file)
      content = File.read(command_file)
      content.valid_encoding?
    rescue => e
      false
    end

  end
end
