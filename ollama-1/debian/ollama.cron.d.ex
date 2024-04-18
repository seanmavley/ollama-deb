#
# Regular cron jobs for the ollama package
#
0 4	* * *	root	[ -x /usr/bin/ollama_maintenance ] && /usr/bin/ollama_maintenance
