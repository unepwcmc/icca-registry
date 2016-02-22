class AssetJoiner
  def initialize first, second
    @first  = first
    @second = second
  end

  def call(input)
    p "hey #{input[:name]}"
    if input[:name] == @second
      prefix = File.read(Rails.root.join('app/assets', @first))
      {data: prefix + "\n" + input[:data]}
    else
      {data: input[:data]}
    end
  end
end
