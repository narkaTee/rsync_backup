#!/usr/bin/env ruby
require "yaml"
require "logger"
require_relative "lib/backup_job"

log = Logger.new(STDOUT)
log.level = Logger::INFO

log.info("Starting Backups")

processes = []

YAML.load_file("backups.yaml").each do | host, config |
    processes.push(
        fork do
            job = BackupJob.new(host, config, log)
            job.run()
        end
    )
end

log.info("#{processes.length} jobs forked")
status = Process.waitall()

worst = 0
status.each do |pid, status|
    exitcode = status.exitstatus
    if (exitcode != 0)
	log.warn("non zero exitstatus from pid #{status.pid}, status: #{exitcode}")
	worst = exitcode
    end
end
exit worst
