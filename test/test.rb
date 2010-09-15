require 'LLVM'

require 'test/unit'

class BridgeTest < Test::Unit::TestCase

  def setup
    @ctx = LLVM::LLVMContext.new
    @module_name = "module"
    @m = LLVM::Module.new(@module_name, @ctx)
  end

  def test_context
    assert_equal @ctx, LLVM::Type.getVoidTy(@ctx).getContext
  end

  def test_module_identifier
    assert_equal @module_name, @m.getModuleIdentifier
    @m.setModuleIdentifier("")
    assert_equal "", @m.getModuleIdentifier
  end

  def test_function
    func = @m.getOrInsertFunction("abc", LLVM::FunctionType.get(LLVM::Type.getVoidTy(@ctx), false))
    assert_equal "abc", func.getNameStr
    assert_equal "abc", func.getName
  end
end
