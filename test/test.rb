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

  def test_typevector
    tv = LLVM::TypeVector.new
    tv << LLVM::Type.getInt32Ty(@ctx)
    tv << LLVM::Type.getInt8Ty(@ctx)
    assert_kind_of LLVM::FunctionType, LLVM::FunctionType.get(LLVM::Type.getVoidTy(@ctx), tv, false)
  end

  def test_execution_engine
    assert_raises ArgumentError do
      LLVM::EngineBuilder.new(nil)
    end

    b = LLVM::EngineBuilder.new @m
    assert_kind_of LLVM::EngineBuilder, b
    e = b.create
    assert_kind_of LLVM::ExecutionEngine, e
  end

  def test_basic_block
    main = @m.getOrInsertFunction("main", LLVM::FunctionType.get(LLVM::Type.getInt32Ty(@ctx), false))
    b = LLVM::BasicBlock.Create(@ctx, LLVM::Twine.new("main"), main)
    assert_kind_of LLVM::BasicBlock, b
    assert_equal main, b.getParent
  end

  def test_APInt
    ff = LLVM::APInt.new(8, 255)
    assert_equal "-1", ff.toString(10, true)
    assert_equal "255", ff.toString(10, false)

    max_64 = 2**64 - 1

    assert_equal "-1", LLVM::APInt.new(64, max_64).toString(10, true)
    assert_equal "-1", LLVM::APInt.new(64, -1, true).toString(10, true)
    assert_equal max_64.to_s, LLVM::APInt.new(64, max_64).toString(10, false)
    assert_equal max_64.to_s, LLVM::APInt.new(64, -1).toString(10, false)

    assert_raises RangeError do
      LLVM::APInt.new(64, max_64 + 1)
    end
  end
end
