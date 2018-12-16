require "time"
require "open3"

class BackupJob
    @@default_config = {
	"user" => "root",
        "paths" => []
    }
    def initialize(host, config, logger)
        @host = host
        @config = @@default_config.merge(config)
        @targetfolder = File.join("hosts", host)
        @log = logger
        @lastrun = File.join(@targetfolder, "lastrun")
    end

    def run()
        if not should_run
            @log.info("Not running backup for #{@host}")
            exit 0
        end

        @log.info("Backing up #{@host} to #{@targetfolder}")
        Dir.mkdir @targetfolder unless Dir.exist?(@targetfolder)
        Dir.chdir(@targetfolder) do
	    stdout, stderr, status = Open3.capture3(
	        "rsync -aRq #{@config.fetch("user")}@#{@host}:#{@config.fetch("paths").join(" :")} ."
	    )
	    if status.exitstatus != 0
		@log.error("Failed backing up: "+ stderr)
		exit 1
	    end
	end
        complete
    end

    def complete()
	@log.info("backup finished!")
        last = File.new(@lastrun, "w+")
        last.write(Time.now)
        last.close
        exit 0
    end

    def should_run()
        # bail out fast if there is no last run
        return true unless File.exist?(@lastrun)
        last = File.new(@lastrun)

        time = last.readline
        begin
            last_time = Time.parse(time)
            now = Time.now()
            frmt = "%Y%m%d"
            now.strftime(frmt) != last_time.strftime(frmt)
        rescue ArgumentError => e
            @log.warn("could not read last time: " + e.message)
            true
        end
    end
end
