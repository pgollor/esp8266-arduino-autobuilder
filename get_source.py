#!/usr/bin/python3
## @file get_source.py
#
# @date 2015-10-03
# @author Pascal Gollor (https://github.com/pgollor/)
#
# Tool to load hardware specific source from Arduino Board Manager URL.
#


import sys, optparse, logging
import json
from urllib.request import urlopen
from urllib.error import HTTPError


## @brief Create option parser and return parser options.
# @return parser options
def parser():
	parser = optparse.OptionParser(
		usage = "%prog [options] -u [url]",
		description = "Download hardware specific data from Arduino board manager url."
	)

	# destination ip and port
	group = optparse.OptionGroup(parser, "Source")
	group.add_option("-u", "--url",
		dest = "source_url",
		action = "store",
		help = "Json source url.",
		default = None
	)
	group.add_option("-t", "--destination",
		dest = "dest_dir",
		action = "store",
		help = "Destination directory. Defautl is ./src/",
		default = "./src/"
	)
	group.add_option("-a", "--architecture",
		dest = "arch",
		action = "store",
		help = "Host i686-mingw32, x86_64-apple-darwin, i386-apple-darwin, x86_64-pc-linux-gnu, i686-pc-linux-gnu",
		default = "x86_64-pc-linux-gnu"
	)
	parser.add_option_group(group)
	# x86_64-pc-linux-gnu

	# output group
	group = optparse.OptionGroup(parser, "Output")
	group.add_option("-d", "--debug",
		dest = "debug",
		help = "Show debug output. And override loglevel with debug.",
		action = "store_true",
		default = False
	)
	parser.add_option_group(group)

	(options, args) = parser.parse_args()

	return options
# end parser


## @brief Get tool url.
# @param toolList Tool dict.
# @param arch Architecture.
def toolUrl(tool, arch):
	systems = tool['systems']
	
	for system in systems:
		if (not system['host'] == arch):
			continue
		# end if
		
		#return {'url': system['url'], 'fileName': system['archiveFileName']}
		
	# end for
	
# end downloadTool


## @brief Handle json content.
# @param url Json URL.
# @param destDir Destination directory.
# @param arch Architecture.
# @return True or False.
def handleJson(url, destDir, arch):
	try:
		res = urlopen(url)
	except HTTPError as e:
		logging.error(str(e))
		
		return False
	# end try
	
	# check destination directory
	if (not destDir.endswith("/")):
		destDir += "/";
	# end if
	
	# read data from url
	info = res.info()
	content = res.read()
	
	# parse to json
	data = json.loads(content.decode(info.get_param('charset') or 'utf-8'))
	
	if ("packages" not in data):
		logging.error("Unknown data structure.")
		
		return 1
	# end if
	
	# get data from json dict
	packages = data['packages'][0]
	platforms = data['packages'][0]['platforms'][0]
	tools = data['packages'][0]['tools']
	
	# get platform package
	url = platforms['url']
	deps = platforms['toolsDependencies']
	fileName = platforms['archiveFileName']
	
	#urlretrieve(url, destDir + fileName)
	
	
	# get tools which platform depends on
	toolList = list()
	for tool in deps:
		toolList.append(tool['name'])
	# end for
	
	for tool in tools:
		name = tool['name']
		
		# download only tools which platform depends on
		if (name not in toolList):
			continue
		# end if
		
		logging.info("Tool: %s with version %s", name, tool['version'])
		
		toolUrl(tool, arch)
	# end for

	return True
# end handleJson


## @brief Main function.
# @return 0: True - otherwise: False
def main():
	# get options
	options = parser()

	# adapt log level
	loglevel = logging.INFO
	if (options.debug):
		loglevel = logging.DEBUG
	# end if

	# logging
	logging.basicConfig(level = loglevel, format = '%(asctime)-8s [%(levelname)s]: %(message)s', datefmt = '%H:%M:%S')

	logging.debug("Options: %s", str(options))

	# check options
	if (not options.source_url):
		logging.critical("Not enough arguments.")

		return 1
	# end if
	
	# handle sata
	if (not handleJson(options.source_url, options.dest_dir, options.arch)):
		return 1
	# end if
	
	return 0
# end main


if __name__ == '__main__':
	sys.exit(main())
# end if
