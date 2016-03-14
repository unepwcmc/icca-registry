module ImagesHelper
  def with2x original_filename
    original_extension = Pathname(original_filename).extname
    double_filename = Pathname(original_filename).sub_ext("@2x#{original_extension}")

    "#{image_path(original_filename)} 1x, #{image_path(double_filename)} 2x"
  end
end
