
def FlagsForFile(filename, **kwargs):

  flags = [
    '-std=c++11',
    #'-Werror',
    '-Weverything',
    '-Wno-c++98-compat',
    '-Wno-c++98-compat-pedantic',
    #'-Wconversion',
    
    #Standard includes
    '-isystem',
    '/usr/include/c++/6.1.1/',
    
    #current dir
    '-I',
    '.',
  ]

# data = kwargs['client_data']
# filetype = data['&filetype']

# if filetype == 'c':
#   flags += ['-xc']
# elif filetype == 'cpp':
#   flags += ['-xc++']
#   flags += ['-std=c++11']
# elif filetype == 'objc':
#   flags += ['-ObjC']
# else:
#   flags = []

  return {
    'flags':    flags,
    'do_cache': True
  }
