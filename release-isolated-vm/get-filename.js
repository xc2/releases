const pkg = require('isolated-vm/package.json')
process.stdout.write(`isolated-vm-${pkg.version}-${process.platform}-${process.arch}-${process.versions.modules}.node`)