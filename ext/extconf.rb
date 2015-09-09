require "mkmf"
require "fileutils"

def sys(cmd)
  puts "  -- #{cmd}"
  unless ret = xsystem(cmd)
    raise "#{cmd} failed, please report issue on https://github.com/wordtreefoundation/melisa"
  end
  ret
end

if `which make`.strip.empty?
  STDERR.puts "\n\n"
  STDERR.puts "***************************************************************************************"
  STDERR.puts "*************** make required (apt-get install make build-essential) =( ***************"
  STDERR.puts "***************************************************************************************"
  exit(1)
end

MARISA_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "marisa-0.2.4"))
PREFIX = File.expand_path(File.join(File.dirname(__FILE__), "pkg"))

# Magic incantation that lets the linker see the installed marisa lib
$LDFLAGS << " -Wl,-rpath,#{File.join(PREFIX, "lib")}"

FileUtils.cd(MARISA_ROOT) do
  sys "./configure --prefix='#{PREFIX}'"
  sys "make"
  sys "make install"
end

$CFLAGS   << " -I#{File.join(PREFIX, 'include')}"
$CPPFLAGS << " -I#{File.join(PREFIX, 'include')}"
$LDFLAGS  << " -L#{File.join(PREFIX, 'lib')} -lmarisa"

create_makefile("marisa")
