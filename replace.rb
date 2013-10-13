text = readlines.join("")

text.gsub!(/class\s(?<class_name>\w+?)\s.+?explicit\s(?<constructer>.+?\})\s+(?<destructer>~.+?\})?\s+void (?<print>print.+?\})\s+\};/m) {
    str = ''
    str << "#{$~['class_name']}::#{$~['constructer']}\n"
    str << "#{$~['class_name']}::#{$~['destructer']}\n" if $~['destructer']
    str << "void #{$~['class_name']}::#{$~['print']}"
}
puts text