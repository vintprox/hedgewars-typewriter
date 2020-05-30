const { src, dest, watch } = require('gulp')
const zip = require('gulp-zip')

const addonName = 'Typewriter'
let majorVersion = process.env.npm_package_version
majorVersion = majorVersion.substring(0, majorVersion.indexOf('.'))
let hwUserDir = `${require('os').homedir()}/.hedgewars`

function buildOnGo() {
	return src('addon/**')
		.pipe(zip(`${addonName}.hwp`))
		.pipe(dest('Data', { cwd: hwUserDir }))
}

function buildMajor() {
	return src('addon/**')
		.pipe(zip(`${addonName}_v${majorVersion}.hwp`))
		.pipe(dest('dist'))
}

exports.default = () => {
  buildOnGo()
  watch('addon/**', { ignoreInitial: false }, buildOnGo)
}
exports.build = buildMajor
