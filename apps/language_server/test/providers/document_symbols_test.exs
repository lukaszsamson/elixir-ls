defmodule ElixirLS.LanguageServer.Providers.DocumentSymbolsTest do
  alias ElixirLS.LanguageServer.Providers.DocumentSymbols
  use ExUnit.Case

  test "returns symbol information" do
    uri = "file://project/file.ex"
    text = ~S[
      defmodule MyModule do
        @my_mod_var "module variable"
        def my_fn(arg), do: :ok
        defp my_private_fn(arg), do: :ok
        defmacro my_macro(), do: :ok
        defmacrop my_private_macro(), do: :ok
        defguard my_guard(a) when is_integer(a)
        defguardp my_private_guard(a) when is_integer(a)
        defdelegate my_delegate(list), to: Enum, as: :reverse
      end
    ]

    assert {:ok,
            [
              %{
                children: [
                  %{
                    children: [],
                    kind: 14,
                    name: "@my_mod_var",
                    range: %{end: %{character: 9, line: 2}, start: %{character: 9, line: 2}},
                    selectionRange: %{
                      end: %{character: 9, line: 2},
                      start: %{character: 9, line: 2}
                    }
                  },
                  %{
                    children: [],
                    kind: 12,
                    name: "my_fn(arg)",
                    range: %{end: %{character: 12, line: 3}, start: %{character: 12, line: 3}},
                    selectionRange: %{
                      end: %{character: 12, line: 3},
                      start: %{character: 12, line: 3}
                    }
                  },
                  %{
                    children: [],
                    kind: 12,
                    name: "my_private_fn(arg)",
                    range: %{end: %{character: 13, line: 4}, start: %{character: 13, line: 4}},
                    selectionRange: %{
                      end: %{character: 13, line: 4},
                      start: %{character: 13, line: 4}
                    }
                  },
                  %{
                    children: [],
                    kind: 12,
                    name: "my_macro()",
                    range: %{end: %{character: 17, line: 5}, start: %{character: 17, line: 5}},
                    selectionRange: %{
                      end: %{character: 17, line: 5},
                      start: %{character: 17, line: 5}
                    }
                  },
                  %{
                    children: [],
                    kind: 12,
                    name: "my_private_macro()",
                    range: %{end: %{character: 18, line: 6}, start: %{character: 18, line: 6}},
                    selectionRange: %{
                      end: %{character: 18, line: 6},
                      start: %{character: 18, line: 6}
                    }
                  },
                  %{
                    children: [],
                    kind: 12,
                    name: "my_guard(a) when is_integer(a)",
                    range: %{end: %{character: 29, line: 7}, start: %{character: 29, line: 7}},
                    selectionRange: %{
                      end: %{character: 29, line: 7},
                      start: %{character: 29, line: 7}
                    }
                  },
                  %{
                    children: [],
                    kind: 12,
                    name: "my_private_guard(a) when is_integer(a)",
                    range: %{end: %{character: 38, line: 8}, start: %{character: 38, line: 8}},
                    selectionRange: %{
                      end: %{character: 38, line: 8},
                      start: %{character: 38, line: 8}
                    }
                  },
                  %{
                    children: [],
                    kind: 12,
                    name: "my_delegate(list)",
                    range: %{end: %{character: 20, line: 9}, start: %{character: 20, line: 9}},
                    selectionRange: %{
                      end: %{character: 20, line: 9},
                      start: %{character: 20, line: 9}
                    }
                  }
                ],
                kind: 2,
                name: "MyModule",
                range: %{end: %{character: 6, line: 1}, start: %{character: 6, line: 1}},
                selectionRange: %{end: %{character: 6, line: 1}, start: %{character: 6, line: 1}}
              }
            ]} = DocumentSymbols.symbols(uri, text)
  end

  test "handles nested module definitions" do
    uri = "file://project/file.ex"
    text = ~S[
      defmodule MyModule do
        defmodule SubModule do
          def my_fn(), do: :ok
        end
      end
    ]

    assert {:ok,
            [
              %{
                children: [
                  %{
                    children: [
                      %{
                        children: [],
                        kind: 12,
                        name: "my_fn()",
                        range: %{
                          end: %{character: 14, line: 3},
                          start: %{character: 14, line: 3}
                        },
                        selectionRange: %{
                          end: %{character: 14, line: 3},
                          start: %{character: 14, line: 3}
                        }
                      }
                    ],
                    kind: 2,
                    name: "SubModule",
                    range: %{
                      end: %{character: 8, line: 2},
                      start: %{character: 8, line: 2}
                    },
                    selectionRange: %{
                      end: %{character: 8, line: 2},
                      start: %{character: 8, line: 2}
                    }
                  }
                ],
                kind: 2,
                name: "MyModule",
                range: %{
                  end: %{character: 6, line: 1},
                  start: %{character: 6, line: 1}
                },
                selectionRange: %{
                  end: %{character: 6, line: 1},
                  start: %{character: 6, line: 1}
                }
              }
            ]} = DocumentSymbols.symbols(uri, text)
  end

  test "handels multiple module definitions" do
    uri = "file://project/file.ex"
    text = ~S[
      defmodule MyModule do
        def some_function(), do: :ok
      end
      defmodule MyOtherModule do
        def some_other_function(), do: :ok
      end
    ]

    assert {:ok,
            [
              %{
                children: [
                  %{
                    children: [],
                    kind: 12,
                    name: "some_function()",
                    range: %{
                      end: %{character: 12, line: 2},
                      start: %{character: 12, line: 2}
                    },
                    selectionRange: %{
                      end: %{character: 12, line: 2},
                      start: %{character: 12, line: 2}
                    }
                  }
                ],
                kind: 2,
                name: "MyModule",
                range: %{
                  end: %{character: 6, line: 1},
                  start: %{character: 6, line: 1}
                },
                selectionRange: %{
                  end: %{character: 6, line: 1},
                  start: %{character: 6, line: 1}
                }
              },
              %{
                children: [
                  %{
                    children: [],
                    kind: 12,
                    name: "some_other_function()",
                    range: %{
                      end: %{character: 12, line: 5},
                      start: %{character: 12, line: 5}
                    },
                    selectionRange: %{
                      end: %{character: 12, line: 5},
                      start: %{character: 12, line: 5}
                    }
                  }
                ],
                kind: 2,
                name: "MyOtherModule",
                range: %{
                  end: %{character: 6, line: 4},
                  start: %{character: 6, line: 4}
                },
                selectionRange: %{
                  end: %{character: 6, line: 4},
                  start: %{character: 6, line: 4}
                }
              }
            ]} = DocumentSymbols.symbols(uri, text)
  end

  test "handles elixir atom module definitions" do
    uri = "file://project/file.ex"
    text = ~S[
      defmodule :'Elixir.MyModule' do
        def my_fn(), do: :ok
      end
    ]

    assert {:ok,
            [
              %{
                children: [
                  %{
                    children: [],
                    kind: 12,
                    name: "my_fn()",
                    range: %{end: %{character: 12, line: 2}, start: %{character: 12, line: 2}},
                    selectionRange: %{
                      end: %{character: 12, line: 2},
                      start: %{character: 12, line: 2}
                    }
                  }
                ],
                kind: 2,
                name: "MyModule",
                range: %{end: %{character: 6, line: 1}, start: %{character: 6, line: 1}},
                selectionRange: %{end: %{character: 6, line: 1}, start: %{character: 6, line: 1}}
              }
            ]} = DocumentSymbols.symbols(uri, text)
  end

  test "handles erlang atom module definitions" do
    uri = "file://project/file.ex"
    text = ~S[
      defmodule :my_module do
        def my_fn(), do: :ok
      end
    ]

    assert {:ok,
            [
              %{
                children: [
                  %{
                    children: [],
                    kind: 12,
                    name: "my_fn()",
                    range: %{end: %{character: 12, line: 2}, start: %{character: 12, line: 2}},
                    selectionRange: %{
                      end: %{character: 12, line: 2},
                      start: %{character: 12, line: 2}
                    }
                  }
                ],
                kind: 2,
                name: "my_module",
                range: %{end: %{character: 6, line: 1}, start: %{character: 6, line: 1}},
                selectionRange: %{end: %{character: 6, line: 1}, start: %{character: 6, line: 1}}
              }
            ]} = DocumentSymbols.symbols(uri, text)
  end

  test "handles nested module definitions with __MODULE__" do
    uri = "file://project/file.ex"
    text = ~S[
      defmodule __MODULE__ do
        defmodule __MODULE__.SubModule do
          def my_fn(), do: :ok
        end
      end
    ]

    assert {:ok,
            [
              %{
                children: [
                  %{
                    children: [
                      %{
                        children: [],
                        kind: 12,
                        name: "my_fn()",
                        range: %{end: %{character: 14, line: 3}, start: %{character: 14, line: 3}},
                        selectionRange: %{
                          end: %{character: 14, line: 3},
                          start: %{character: 14, line: 3}
                        }
                      }
                    ],
                    kind: 2,
                    name: "__MODULE__.SubModule",
                    range: %{end: %{character: 8, line: 2}, start: %{character: 8, line: 2}},
                    selectionRange: %{
                      end: %{character: 8, line: 2},
                      start: %{character: 8, line: 2}
                    }
                  }
                ],
                kind: 2,
                name: "__MODULE__",
                range: %{end: %{character: 6, line: 1}, start: %{character: 6, line: 1}},
                selectionRange: %{end: %{character: 6, line: 1}, start: %{character: 6, line: 1}}
              }
            ]} = DocumentSymbols.symbols(uri, text)
  end

  test "handles protocols and implementations" do
    uri = "file://project/file.ex"

    text = """
    defprotocol MyProtocol do
      @doc "Calculates the size"
      def size(data)
    end

    defimpl MyProtocol, for: BitString do
      def size(binary), do: byte_size(binary)
    end

    defimpl MyProtocol, for: [List, MyList] do
      def size(param), do: length(param)
    end
    """

    assert {:ok,
            [
              %{
                children: [
                  %{
                    children: [],
                    kind: 12,
                    name: "size(data)",
                    range: %{end: %{character: 6, line: 2}, start: %{character: 6, line: 2}},
                    selectionRange: %{
                      end: %{character: 6, line: 2},
                      start: %{character: 6, line: 2}
                    }
                  }
                ],
                kind: 2,
                name: "MyProtocol",
                range: %{end: %{character: 0, line: 0}, start: %{character: 0, line: 0}},
                selectionRange: %{end: %{character: 0, line: 0}, start: %{character: 0, line: 0}}
              },
              %{
                children: [
                  %{
                    children: [],
                    kind: 12,
                    name: "size(binary)",
                    range: %{end: %{character: 6, line: 6}, start: %{character: 6, line: 6}},
                    selectionRange: %{
                      end: %{character: 6, line: 6},
                      start: %{character: 6, line: 6}
                    }
                  }
                ],
                kind: 2,
                name: "MyProtocol, for: BitString",
                range: %{end: %{character: 0, line: 5}, start: %{character: 0, line: 5}},
                selectionRange: %{end: %{character: 0, line: 5}, start: %{character: 0, line: 5}}
              },
              %{
                children: [
                  %{
                    children: [],
                    kind: 12,
                    name: "size(param)",
                    range: %{end: %{character: 6, line: 10}, start: %{character: 6, line: 10}},
                    selectionRange: %{
                      end: %{character: 6, line: 10},
                      start: %{character: 6, line: 10}
                    }
                  }
                ],
                kind: 2,
                name: "MyProtocol, for: [List, MyList]",
                range: %{end: %{character: 0, line: 9}, start: %{character: 0, line: 9}},
                selectionRange: %{end: %{character: 0, line: 9}, start: %{character: 0, line: 9}}
              }
            ]} = DocumentSymbols.symbols(uri, text)
  end

  test "handles exunit tests" do
    uri = "file://project/test.exs"
    text = ~S[
      defmodule MyModuleTest do
        use ExUnit.Case
        test "does something", do: :ok
      end
    ]

    assert {:ok,
            [
              %{
                children: [
                  %{
                    children: [],
                    kind: 12,
                    name: "test \"does something\"",
                    range: %{
                      end: %{character: 8, line: 3},
                      start: %{character: 8, line: 3}
                    },
                    selectionRange: %{
                      end: %{character: 8, line: 3},
                      start: %{character: 8, line: 3}
                    }
                  }
                ],
                kind: 2,
                name: "MyModuleTest",
                range: %{
                  end: %{character: 6, line: 1},
                  start: %{character: 6, line: 1}
                },
                selectionRange: %{
                  end: %{character: 6, line: 1},
                  start: %{character: 6, line: 1}
                }
              }
            ]} = DocumentSymbols.symbols(uri, text)
  end

  test "handles exunit descibe tests" do
    uri = "file://project/test.exs"
    text = ~S[
      defmodule MyModuleTest do
        use ExUnit.Case
        describe "some descripton" do
          test "does something", do: :ok
        end
      end
    ]

    assert {:ok,
            [
              %{
                children: [
                  %{
                    children: [
                      %{
                        children: [],
                        kind: 12,
                        name: "test \"does something\"",
                        range: %{
                          end: %{character: 10, line: 4},
                          start: %{character: 10, line: 4}
                        },
                        selectionRange: %{
                          end: %{character: 10, line: 4},
                          start: %{character: 10, line: 4}
                        }
                      }
                    ],
                    kind: 12,
                    name: "describe \"some descripton\"",
                    range: %{
                      end: %{character: 8, line: 3},
                      start: %{character: 8, line: 3}
                    },
                    selectionRange: %{
                      end: %{character: 8, line: 3},
                      start: %{character: 8, line: 3}
                    }
                  }
                ],
                kind: 2,
                name: "MyModuleTest",
                range: %{
                  end: %{character: 6, line: 1},
                  start: %{character: 6, line: 1}
                },
                selectionRange: %{
                  end: %{character: 6, line: 1},
                  start: %{character: 6, line: 1}
                }
              }
            ]} = DocumentSymbols.symbols(uri, text)
  end
end
