Pod::Spec.new do |s|

  s.name         = "EasyTimeline"
  s.version      = "0.0.1"
  s.summary      = "An easy timeline class for your timeline needs"

  s.description  = <<-DESC
                   An easy timeline class for your timeline needs
                   DESC

  s.homepage     = "https://github.com/mmislam101/EasyTimeline"


  s.license      = 'unlicense'
  s.author       = { "Mohammed Islam" => "" }
  s.source       = { :git => "https://github.com/mmislam101/EasyTimeline.git", :commit => "e657c34d5a9918cb2862b702bc368a9333a9a5e8" }

  s.source_files  = 'EasyTimeline', 'EasyTimeline/*.{h,m}'
end
