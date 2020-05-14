class String
  def searchize
    squish.parameterize(separator: ' ')
  end

  def regexize
    /.*#{searchize}.*/
  end
end
