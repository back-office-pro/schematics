class String
  def extends(heredoc)
    squish + " " + heredoc
  end

  def extends_with_comma(heredoc)
    squish + ", " + heredoc
  end
end
