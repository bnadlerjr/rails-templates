class Commands
  def initialize
    @pre_bundle = []
    @post_bundle = []
  end

  def pre_bundle(&block)
    @pre_bundle << block
  end

  def post_bundle(&block)
    @post_bundle << block
  end

  def execute(type)
    commands = :pre_bundle == type ? @pre_bundle : @post_bundle
    commands.each { |p| p.call }
  end
end
