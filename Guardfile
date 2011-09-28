# https://github.com/guard/guard#readme

guard "compass" do
  watch(/^sass\/(.*)\.s[ac]ss/)
end

guard 'coffeescript', :input => 'coffee', :output => 'public/js'


guard 'livereload' do
  watch %r{coffee/.+\.coffee}
  watch %r{sass/.+\.sass}
  watch %r{views/.+\.haml}
  watch %r{models/.+\.rb}
  watch %r{.+\.rb}
  watch %r{lib/.+\.rb}
end
