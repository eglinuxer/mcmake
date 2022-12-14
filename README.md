# mcmake
本仓库记录一些 CMake 例子和 CMake 语法规则，以及一些 cmake 命令行和 GUI 界面程序的使用。

第 0-2 三个章节主要是记录一些 CMake 常用的基本概念和知识，并没有深入展开分享。看不懂没关系，从第 3 章开始，遇到前面提到的知识点就会展开分享。不过不要直接跳到第 3 章节开始看，因为前面三个章节介绍了很多基本概念和知识，能够让你对 CMake 有一个感性的认识。并不要求初学者一开始第一遍就看懂这三个章节的内容，有个印象就行了。

特别是第 1-2 两个章节的内容，只是简单列出 CMake 常用的知识点，目的是方便工作在 CMake 工程的时候查阅和复习。

需要提醒一下，本仓库只使用 C++ 语言演示 CMake 项目。

如需交流，请移步微信公众号: eglinux

<img src=".assets/image-20220803235838745.png" alt="公众号二维码" style="zoom:25%;" />

## 0. CMake 简介
- examples/0/00.cpp
  - g++ 00.cpp

像上面这个例子，如果只有一个或者几个源文件，我们可以简单的自己敲命令进行编译。倘若是一个稍大一点的项目，有很多的源文件，而且这些源文件为了项目的结构清晰，通常会分布在不同的目录，难道我们还是手动去敲命令进行编译吗？那这条命令得有多长？

早期大家喜欢用 Makefile 来组织一个项目的编译构建和安装。就算是现在，仍然有许多的项目在使用 Makefile。

同样也有人喜欢用 [GNU Automake](https://www.gnu.org/software/automake/) 。如果你接触过一些开源项目，我相信你一定对下面这些命令不陌生：

```shell
$ ./configure
$ make
$ make verify   # (optional)
$ sudo make install
```

不错，这就是使用 Automake 管理的编译构建和安装的项目的常规操作。可以看出，其实最终都要和 Makefile 扯上关系。

当然这些都偏向于 Linux 系统上的操作，其实在 Windows 和 macOS 上通常有 IDE 加持，所以很多人就直接不用担心底层到底是怎么编译构建的，只需要按照项目的组织结构直接在 IDE 里面添加源文件就可以了。

但是如果有跨平台的需求，那 IDE 的支持就不是那么好了。

那有没有一种工具，可以管理编译构建和安装，还能够做到跨平台呢？CMake 就是这样的存在，当然除了 CMake，还有其他工具也能做到，比如：[bazel](https://bazel.build/) 、[meson](https://mesonbuild.com/) 、[boost b2](https://www.boost.org/doc/libs/1_79_0/tools/build/doc/html/index.html) 等。

因为本仓库的主角是 CMake，我们就不对其他工具做介绍，也不对这些工具之间做对比，避免无谓的争论不休。

### 0.1. CMake 配置阶段

- 创建一个空的构建目录，并将其工作环境的详细信息收集到其中，例如：系统架构、可用的编译器、链接器、归档器等。
- 尝试测试一个简单的例子，看看是否能正常编译。
- 解析 CMakeLists.txt 文件
  - 项目结构
  - 构建目标
  - 依赖

### 0.2. 生成阶段

- 生成构建系统
- 这个阶段可以通过生成器表达式对构建配置做最后的修改

### 0.3. 构建阶段

- 编译
- 链接
- 单元测试
- 安装
- 打包

看一个简单的例子：

- examples/0

  ```shell
  cd examples/0
  # 配置阶段以及生成阶段合二为一
  cmake -S . -B build
  
  # 构建阶段
  cmake --build build
  ```

## 1. CMake 命令行用法

### 1.1. cmake

- 生成项目的构建系统

  ```shell
  # 推荐用法
  cmake [<options>] -S <path-to-source> -B <path-to-build>
  
  # 不推荐的用法
  cmake [<options>] <path-to-source>
  
  # 一般是之前运行过一次，已经生成过
  cmake [<options>] <path-to-existing-build>
  ```

- 指定生成器

  ```shell
  cmake -G <generator-name> -S <path-to-source> -B <path-to-build>
  ```

- 指定工具集和平台

  ```shell
  cmake -G <generator-name> -T <toolset-spec> -A <platform-name> -S <path-to-source> -B <path-to-build>
  ```

- 查看帮助

  ```shell
  cmake --help
  cmake ––help[-<topic>]
  ```

- 指定缓存变量的值

  ```shell
  cmake -D <var>[:<type>]=<value> -S <path-to-source> -B <path-to-build>
  # -D 可以重复多次
  ```

  - 如果要指定的缓存变量太多，可以将要指定的缓存变量用 set() 命令定义，全部写到一个 xxx.cmake 脚本文件中，该 CMake 脚本文件只包含 set() 命令，例如：

    ```cmake
    set(var1 "1111" CACHE STRING "docstring")
    set(var1 "2222" CACHE STRING "docstring")
    set(var1 "3333" CACHE STRING "docstring")
    set(var1 "4444" CACHE STRING "docstring")
    ```

    然后就可以使用 cmake 命令的 -C 选项指定该脚本文件：

    ```shell
    cmake -C xxx.cmake -S <path-to-source> -B <path-to-build>
    ```

  - type 可以是如下值，如果没有指定则为 UNINITIALIZED

    - BOOL
    - FILEPATH
    - PATH
    - STRING
    - INTERNAL

- 取消缓存变量的定义

  ```shell
  cmake -U <globbing_expr> -S <path-to-source> -B <path-to-build>
  # globbing_expr 支持 * 和 ? 通配符
  # -U 可以重复多次
  ```

- 指定构建类型

  ```shell
  cmake -S . -B build -D CMAKE_BUILD_TYPE=Release
  # Debug, Release, MinSizeRel, or RelWithDebInfo.
  ```

- 指定 CMake 输出日志等级

  ```shell
  cmake --log-level=<level>
  # ERROR, WARNING, NOTICE, STATUS, VERBOSE, DEBUG, or TRACE

- 让 CMAKE_MESSAGE_CONTEXT 生效

  - 为了让日志输出有层次感，通常在不同的作用域开始的时候可以使用如下语句增加日志输出层次定义

    ```cmake
    list(APPEND CMAKE_MESSAGE_CONTEXT top)

    # ....

    # 假设这里开启了新的作用域
    list(APPEND CMAKE_MESSAGE_CONTEXT sub)
    ```

  - 为了让上面的定义生效，配置的时候需要给 cmake 传参，如下：

    ```shell
    cmake --log-context -S <path-to-source> -B <path-to-build>
    ```

- 让 CMake 输出更多的详细信息

  ```shell
  cmake --trace
  ```

- cmake 预设

  - 查看可用预设

    ```shell
    cmake --list-presets
    ```

  - 指定预设

    ```shell
    cmake --preset=<preset>
    ```

- 关于缓存变量值覆盖问题

  - -D 指定的缓存变量覆盖预设中定义的缓存变量
  - 预设定义的缓存变量覆盖已有的缓存变量，预设中定义的环境变量覆盖已有的环境变量

- 构建一个项目

  ```shell
  cmake --build <dir> [<options>] [-- <build-tool-options>]
  ```

  - 多线程构建

    ```shell
    cmake --build <dir> --parallel [<number-of-jobs>]
    cmake --build <dir> -j [<number-of-jobs>]
    ```

  - 指定要单独构建的目标

    ```shell
    cmake --build <dir> --target <target1> -t <target2> ...
    ```

  - 清理构建

    ```shell
    cmake --build <dir> -t clean
    ```

  - 指定要构建的类型

    ```shell
    cmake --build <dir> --config <cfg>
    # cfg 可以是：Debug, Release, MinSizeRel, or RelWithDebInfo
    ```

  - 输出构建详细日志

    ```shell
    cmake --build <dir> --verbose
    cmake --build <dir> -v
    ```

- 安装一个项目

  ```shell
  cmake --install <dir> [<options>]
  ```

  - 指定要安装的构建类型

    ```shell
    cmake --install <dir> --config <cfg>
    # cfg 可以是：Debug, Release, MinSizeRel, or RelWithDebInfo
    ```

  - 指定要安装的组建

    ```shell
    cmake --install <dir> --component <comp>
    ```

  - 指定安装的权限

    ```shell
    cmake --install <dir> --default-directory-permissions <permissions>
    # permissions 格式：u=rwx,g=rx,o=rx
    ```

  - 指定安装目录前戳

    ```shell
    cmake --install <dir> --prefix <prefix>
    ```

  - 安装的时候输出详细日志

    ```shell
    cmake --install <dir> --verbose
    cmake --install <dir> -v
    ```

- 运行一个 CMake 脚本

  ```shell
  cmake [{-D <var>=<value>}...] -P <cmake-script-file> [-- <unparsed-options>...]
  # [-- <unparsed-options>...] 传递的参数，CMake 通过 CMAKE_ARGV<n> 变量来接收
  ```

- 运行其他工具命令

  ```shell
  cmake -E <command> [<options>]
  # 例如：cat, chdir, compare_files, copy, copy_directory, copy_if_different, echo, echo_append 等
  ```

- 生成可视化 target 依赖关系图

  ```shell
  cmake --graphviz=test.dot .
  # https://dreampuf.github.io/GraphvizOnline/
  ```

  - 上面的命令生成的依赖关系图不包含用户自定义 target，如果要包含，需要新建一个 CMakeGraphVizOptions.cmake 文件，然后通过这个 CMake 脚本自定义如何生成 target 关系图

    ```cmake
    set(GRAPHVIZ_CUSTOM_TARGETS TRUE)
    # 更多选项参考官方文档

### 1.2. ctest

### 1.3. cpack

## 2. CMake 语言语法规则

### 2.1. 注释

- 单行注释

  ```cmake
  # single-line comments start with a hash sign "#"
  # they can be placed on an empty line
  #
  message("Hi"); # or after a command like here.
  ```

- 括号注释

  ```cmake
  #[=[
  括号注释
    支持嵌套多行注释
    #[[
      nested bracket comment
    #]]
  #]=]
  ```

  - 如果需要取消多行注释，直接在 #[=[ 前再加一个 #，知道 lua 语言的注释的朋友对此应该不陌生。

### 2.2. CMake 命令

![image-20220804002020555](.assets/image-20220804002020555.png)

- 命令分类
  - 脚本命令
  - 项目命令
  - CTest 命令

- 命令参数
  - 不带引号的参数

    ```cmake
    message(a\ single\ argument)
    message(two arguments)
    message(three;separated;arguments)
    message(${CMAKE_VERSION})  # a variable reference
    message(()()())            # matching parentheses
    ```

  - 带引号的参数

    ```cmake
    message("1. escape sequence: \" \n in a quoted argument")
    message("2. multi...
      line")
    message("3. and a variable reference: ${CMAKE_VERSION}")
    ```

  - 括号参数

    ```cmake
    message([[multiline
        bracket
        argument
    ]])
    message([==[
        because we used two equal-signs "=="
        following is still a single argument:
        { "petsArray" = [["mouse","cat"],["dog"]] }
    ]==])
    ```

### 2.3. 变量

- set() 命令定义变量

  ```cmake
  set(MyString1 "Text1")
  set([[My String2]] "Text2")
  set("My String 3" "Text3")

  # ${} 可以引用变量，支持嵌套，评估的时候先里后外
  message(${MyString1})
  message(${My\ String2})
  message(${My\ String\ 3})
  ```

  - 定义普通变量

    ```cmake
    set(varName value... [PARENT_SCOPE])
    ```

  - 普通变量引用

    ```cmake
    ${}
    ```

  - 定义和取消环境变量

    ```cmake
    # set(ENV{<variable>} <value>)
    # unset(ENV{<variable>})
    set(ENV{CXX} "clang++")
    ```

  - 环境变量引用

    ```cmake
    $ENV{}
    ```

  - 定义缓存变量

    ```cmake
    # set(<variable> <value> CACHE <type> <docstring> [FORCE])
    set(FOO "BAR" CACHE STRING "interesting value")
    # type 可以是: BOOL、FILEPATH、PATH、STRING、INTERNAL
    ```

    - 给 STRING 类型的缓存变量设置属性

      ```cmake
      set_property(CACHE <variable> STRINGS <values>).

  - 缓存变量引用

    ```cmake
    $CACHE{}
    ```

  - lists

    ```cmake
    set(myList "a;list;of;five;elements")
    set(myList a list "of;five;elements")
    ```

- list() 命令

  ```cmake
  list(LENGTH <list> <out-var>)
  list(GET <list> <element index> [<index> ...] <out-var>)
  list(JOIN <list> <glue> <out-var>)
  list(SUBLIST <list> <begin> <length> <out-var>)
  list(FIND <list> <value> <out-var>)
  list(APPEND <list> [<element>...])
  list(FILTER <list> {INCLUDE | EXCLUDE} REGEX <regex>)
  list(INSERT <list> <index> [<element>...])
  list(POP_BACK <list> [<out-var>...])
  list(POP_FRONT <list> [<out-var>...])
  list(PREPEND <list> [<element>...])
  list(REMOVE_ITEM <list> <value>...)
  list(REMOVE_AT <list> <index>...)
  list(REMOVE_DUPLICATES <list>)
  list(TRANSFORM <list> <ACTION> [...])
  list(REVERSE <list>)
  list(SORT <list> [...])
  ```

### 2.4. CMake 流程控制

- if() 命令

  ```cmake
  if(<condition>)
    	<commands>
  elseif(<condition>) # optional block, can be repeated
    	<commands>
  else()              # optional block
    	<commands>
  endif()
  ```

  - condition 变体

    ```cmake
    if(NOT <condition>)
    if(<condition> AND <condition>)
    if(<condition> OR <condition>)
    if((<condition>) AND (<condition> OR (<condition>)))

    if(DEFINED <name>)
    if(DEFINED CACHE{<name>})
    if(DEFINED ENV{<name>})

    if (1 LESS 2)
    # EQUAL, LESS, LESS_EQUAL, GREATER, and GREATER_EQUAL

    if (1.3.4 VERSION_LESS_EQUAL 1.4)

    if ("A" STREQUAL "${B}")

    if(<VARIABLE|STRING> MATCHES <regex>)
    # CMAKE_MATCH_<n>

    if(<VARIABLE|STRING> IN_LIST <VARIABLE>)

    if(COMMAND <command-name>)
    if(POLICY <policy-id>)
    if(TEST <test-name>)
    if(TARGET <target-name>)

    if(EXISTS <path-to-file-or-directory>)
    if(<file1> IS_NEWER_THAN <file2>)
    if(IS_DIRECTORY path-to-directory)
    if(IS_SYMLINK file-name)
    if(IS_ABSOLUTE path)
    ```

  - 如果 condition 是一个字符串，那只有和以下值相等的时候条件块才为真

    - `ON`, `Y`, `YES`, or `TRUE`
    - 一个非 0 数字

    不过需要注意：如果 condition 是一个没引号的字符串，只有其不等于如下值时才会将其视为一个变量去评估:

    - `OFF`, `NO`, `FALSE`, `N`, `IGNORE`, `NOTFOUND`
    - 以 -NOTFOUND 结尾的字符串
    - 空字符串
    - 0

- 循环

  ```cmake
  while(<condition>)
    	<commands>
  endwhile()
  ```

  ```cmake
  foreach(<loop_var> RANGE <max>)
    	<commands>
  endforeach()
  
  foreach(<loop_var> RANGE <min> <max> [<step>])
  
  foreach(<loop_variable> IN [LISTS <lists>] [ITEMS <items>])
  
  foreach(<loop_var>... IN ZIP_LISTS <lists>)
  ```

  ```cmake
  set(L1 "one;two;three;four")
  set(L2 "1;2;3;4;5")
  foreach(num IN ZIP_LISTS L1 L2)
      message("num_0=${num_0}, num_1=${num_1}")
  endforeach()
  
  # -----------------------------------------------
  foreach(word num IN ZIP_LISTS L1 L2)
      message("word=${word}, num=${num}")
  endforeach()
  ```

  ```cmake
  break()
  continue()
  ```


### 2.5. 自定义命令

- 宏

  ```cmake
  macro(<name> [<argument>…])
    	<commands>
  endmacro()
  ```

- 函数

  ```cmake
  function(<name> [<argument>…])
    	<commands>
    	return()
  endfunction()
  ```

- 命令参数解析

  ```cmake
  ${ARGC}
  ${ARGV}
  ${ARG0},${ARG1}, ${ARG2}
  ${ARGN}
  ```

### 2.6. 实用命令

- message()

  ```cmake
  message(<MODE> "text")
  # FATAL_ERROR、SEND_ERROR、WARNING、AUTHOR_WARNING、DEPRECATION、NOTICE、STATUS、VERBOSE、DEBUG、TRACE
  ```

- include()

  ```cmake
  include(<file|module> [OPTIONAL] [RESULT_VARIABLE <var>])
  ```

- inclue_guard()

  ```cmake
  include_guard([DIRECTORY|GLOBAL])
  # DIRECTORY 保护当前目录及其之下的目录
  # GLOBAL 保护整个构建
  ```

- file()

  ```cmake
  file(READ <filename> <out-var> [...])
  file({WRITE | APPEND} <filename> <content>...)
  file(DOWNLOAD <url> [<file>] [...])
  ```

- execute_process()

  ```cmake
  execute_process(COMMAND <cmd1> [<arguments>]… [OPTIONS])
  # TIMEOUT <seconds>
  # WORKING_DIRECTORY <directory>
  # RESULTS_VARIABLE <variable>
  # RESULT_VARIABLE <variable>
  
  # OUTPUT_VARIABLE 指定变量接收 stdout 输出
  # ERROR_VARIABLE 指定变量接收 stderr 输出
  # 如果想 stdout 和 stderr 输出在一起，则指定成同一个变量即可
  ```

## 3. CMake 实战

通过上面三个章节的 CMake 基础知识的梳理，我相信大家对 CMake 已经有了一些了解了。当然前面三个章节的知识点并没有详细展开说明，只是把常用的一些知识点列出来，目的是为了方便查询和复习。

如果大家对其中的某个知识点感兴趣可以自行查阅相关资料深入学习，也可以和我一起交流。当然后面的分享也会包括其中一些知识点的深入讨论，如果不是太着急要搞明白，我还是建议通篇依次阅读本文档进行 CMake 的学习。

从本章节开始，我会从小项目开始，介绍 CMake 在实际开发中该怎么使用，最后会综合这些使用方法，总结如何使用 CMake 组织大型项目。

### 3.1. 指定 CMake 最小版本

请记住，开始写 CMakeLists.txt 或者 .cmake 脚本的第一件事就是要想清楚自己需要的 CMake 最小版本。

对于新开的项目，不要犹豫，直接选择 cmake 官网的最新稳定版本作为项目的最小 CMake 版本。因为 CMake 安装包很完善，每个平台都能轻松安装最新版本的 CMake，所以不要担心指定太行的 CMake 版本作为最小版本会遇到麻烦，这样给你带来的只有好处。

为了驱动项目合作伙伴也使用最新版本的 CMake，不妨使用下面这条语句，迫使大家都使用最新版本。

```cmake
cmake_minimum_required(VERSION 3.23 FATAL_ERROR)
# 写作本文档时，CMake 的最新版本时 3.23.2
# 加上 FATAL_ERROR 关键字后，如果使用的版本低于 3.23，那 CMake 将在配置的时候发出错误并结束处理
```

另外，上面这条语句应该加在顶级 CMakeLists.txt 的第一行，如果是一个 .cmake 脚本文件， 那第一行也要加上上面这条语句。其他子目录的 CMakeLists.txt 就不建议再包含该语句了，如果要包含，切记要和顶级目录中的该语句一模一样，确保是相同的版本号。

因为 CMake 在通过上面这条语句声明 CMake 的最小版本的同时，也引入了相应的 CMake 策略。关于 CMake 策略这里不展开描述，后续会专门讲解。你只需要知道不同的 CMake 策略会导致 CMake 的行为有所差异就行了。

当我们在 CMakeLists.txt 中写下上面这条语句的时候，相当于隐式调用了一条设置 CMake 策略的语句，如下：

```cmake
cmake_policy(VERSION)
# 这里的 VERSION 要替换成相应的策略版本号，例如 CMake 3.23 的策略版本号是 CMP0129
# 也就是在真实的项目中，如果我们要显示的设置 CMake 策略，语句类似这样的：cmake_policy(CMP0129)
```

不同 CMake 版本的策略版本号可以在 CMake 官网查到：[cmake 策略](https://cmake.org/cmake/help/v3.23/manual/cmake-policies.7.html)

不过只要我们确 cmake_minimum_required() 命令指定的最小版本是最新的 CMake 版本，一般不用考虑 CMake 策略的事情，除非是要维护老版本 CMake 项目。这也是推荐大家在 CMakeLists.txt 中指定最新版本作为当前项目的最小 CMake 版本的原因。

### 3.2. 定义一个项目

- 定义项目的命令

  ```cmake
  project(<PROJECT-NAME> [<language-name>...])
  project(<PROJECT-NAME>
      [VERSION <major>[.<minor>[.<patch>[.<tweak>]]]]
      [DESCRIPTION <project-description-string>]
      [HOMEPAGE_URL <url-string>]
      [LANGUAGES <language-name>...]
  )

可以看到，定义项目，我们可以使用两种形式，如果是想要作为单独的项目，建议使用第二种形式，如果只是作为一个大项目中的小项目，建议使用第一种形式。

也就是说，如果要作为一个单独的项目存在，那在顶级目录的 CMakeLists.txt 中就推荐使用第二种形式定义一个总的项目，在该项目的子目录中，如果有需要，可以使用第二种形式定义一些子项目。

这里提到了子目录，CMake 支持安装源码的目录结构使用 CMakeLists.txt 组织 CMake 项目，也就是说，每一个子目录都可以有一个单独的 CMakeLists.txt 文件，然后使用 CMake 包含子目录的机制将这些分散在各个目录的 CMakeLists.txt 联系起来，这个后面会讲到。

- 说明一下：
  - 上面这种命令我成为 CMake 命令的签名，在实际项目中，某些字段是要替换成我们自己的值的。
  - 其中 <> 包含的字段是必填项
  - [  ] 包含的字段是可选项
  - 每个 CMakeLists.txt 中只能有一条 project() 命令

当我们在 CMakeLists.txt 中写下上述两种形式的命令时，CMake 都会隐式生成一些变量并初始化。如下：

```cmake
# PROJECT_NAME					# <PROJECT-NAME> 的指定的值
# CMAKE_PROJECT_NAME 		# 顶级目录中的 CMakeLists 定义项目的时候 <PROJECT-NAME> 的指定的值
# PROJECT_SOURCE_DIR、PROJECT-NAME>_SOURCE_DIR # 定义项目的时候 CMakeLists.txt 所在的目录
# ROJECT_BINARY_DIR、<PROJECT-NAME>_BINARY_DIR # 定义项目的时候，生成该项目二进制文件存放的目录
```

- 支持的语言

  ```cmake
  # [<language-name>...] 可选参数可以指定如下语言：
  # C, CXX (C++), CUDA, OBJC (Objective-C), OBJCXX (Objective C++), Fortran, ISPC, ASM, CSharp (C#) 和 Java
  ```

  如果没有指定，CMake 会默认指定为 C CXX

  建议如果明确只使用一种语言，那就一定要指定，否则 CMake 默认会去探测 C 和 C++ 的编译器信息，假如我们只使用 C++ 语言，那探测 C 语言编译器的时间就不应该出现。

- 指定项目版本号

  - 对于顶级 CMakeLists.txt 中定义的项目，建议写上版本号，这样也方便做版本发布。

  - 如果指定了版本号，CMake 会隐式生成如下变量

    ```cmake
    # PROJECT_VERSION, <PROJECT-NAME>_VERSION
    # CMAKE_PROJECT_VERSION (只有顶级 CMakeLists.txt 才会生成该变量)
    # PROJECT_VERSION_MAJOR, <PROJECT-NAME>_VERSION_MAJOR
    # PROJECT_VERSION_MINOR, <PROJECT-NAME>_VERSION_MINOR
    # PROJECT_VERSION_PATCH, <PROJECT-NAME>_VERSION_PATCH
    # PROJECT_VERSION_TWEAK, <PROJECT-NAME>_VERSION_TWEAK
    ```

你可能会问，CMake 为什么要隐式生成上述这些变量，不要着急，我们后面会用到，到时候你就知道这些变量带来的便利了。

### 3.3. 让 CMake 日志更友好

对于专注于编程语言本身的工程师来说，CMake 配置生成以及编译产生的日志可能并不需要关心，但对于编写 CMakeLists.txt 的工程师来说，一个良好的 CMake 日志输出对于 debug CMake 工程就会非常有帮助。

CMake 输出日志使用 message() 命令，其形式如下：

```cmake
message([mode] msg1 [msg2]...)
```

- 在前面我们简单说过 message() 是 CMake 非常实用的一条命令，主要就是用来输出日志，方便给管理 CMake 工程的工程师提供 CMake 运行时的一些信息及遇到问题的时候 debug。其支持的日志等级（[mode]）如下：
  - FATAL_ERROR
    - CMake 遇到这个等级的 message() 命令时，会将此条日志输出后就退出，表示有致命错误需要工程师修复后才能继续运行
  - SEND_ERROR
    - 当这个等级的 message() 命令出现的时候，CMake 输出错误信息后回继续处理完配置阶段，但是不会处理生成阶段。容易和 FATAL_ERROR 混淆，建议避免使用。
  - WARNING
    - 输出警告信息，处理将继续
  - AUTHOR_WARNING
    - 这个等级主要是给开发 CMake 本身的工程师使用的，只有在 cmake 命令使用 -Wno-dev 参数时才会输出，对于使用 CMake 的工程师来说不要使用这个等级
  - DEPRECATION
    - 用于输出一些表示弃用的信息给工程师，一般在 CMake 项目中不会使用。
  - NOTICE
    - 输出提示信息，如果非必要，避免使用这个等级
  - STATUS
    - 在 CMake 项目中经常使用这个等级输出单行信息，CMake 默认只会打印比这个等级高或者相等的 message() 命令
  - VERBOSE
    - 用于输出更详细的信息，默认不输出
  - DEBUG
    - 调试级别的信息，一般只有维护 CMake 工程的工程师才会使用
  - TRACE
    - 会输出非常详细的日志信息

在运行 cmake 命令的时候，我们可以传递 --log-level 参数，用于指定要输出的最低日志等级，不指定的话默认时 STATUS，例如：

```shell
cmake --log-level=VERBOSE ...
```

为了让输出的日志能够区分时那个 CMakeLists.txt 输出的，我们可以使用 CMAKE_MESSAGE_CONTEXT，直接看个例子(examples/3/)就明白了：

- 顶级目录 CMakeLists.txt

  ```cmake
  cmake_minimum_required(VERSION 3.24)
  list(APPEND CMAKE_MESSAGE_CONTEXT Top)
  project(test)
  message("test message log start")
  add_subdirectory(test1)
  add_subdirectory(test2)
  message("test message log stop")
  ```

- test1/CMakeLists.txt

  ```cmake
  list(APPEND CMAKE_MESSAGE_CONTEXT test1)
  message("This is a test log")
  ```

- test2/CMakeLists.txt

  ```cmake
  list(APPEND CMAKE_MESSAGE_CONTEXT test2)
  message("This is a test log")
  ```

  输出如下：

  ```cmake
  $ cmake -S . -B build --log-context                                                                                                                                                                                      
  -- [Top] The C compiler identification is AppleClang 13.1.6.13160021
  -- [Top] The CXX compiler identification is AppleClang 13.1.6.13160021
  -- [Top] Detecting C compiler ABI info
  -- [Top] Detecting C compiler ABI info - done
  -- [Top] Check for working C compiler: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc - skipped
  -- [Top] Detecting C compile features
  -- [Top] Detecting C compile features - done
  -- [Top] Detecting CXX compiler ABI info
  -- [Top] Detecting CXX compiler ABI info - done
  -- [Top] Check for working CXX compiler: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ - skipped
  -- [Top] Detecting CXX compile features
  -- [Top] Detecting CXX compile features - done
  [Top] test message log start
  [Top.test1] This is a test log
  [Top.test2] This is a test log
  [Top] test message log stop
  -- Configuring done
  -- Generating done
  -- Build files have been written to: /Users/eg/file/code/github/mcmake/examples/3/build
  ```

### 3.4. 禁止源内构建

先说下什么是源内构建和源外构建：

- 源内构建
  - 构建目录在源码目录中或者构建目录和源码目录是同一个目录
- 源外构建
  - 构建目录在源码目录之外

源内构建，特别是构建目录和源码目录是同一个目录的时候，构建输出的文件会和源码文件混淆在一起，有时甚至会覆盖源码文件，为了避免出现这种情况，一般建议使用源外构建，这也是很多支持 CMake 的 IDE 的默认做法。

虽然源外构建能够隔离源码目录和构建目录，确保源码不被污染，但是这也让构建目录和源码目录之间失去联系。我的推荐是使用改良的源内构建，也就是在源码目录里面新建一个构建目录，这样既能让构建和源码隔离，也能让构建目录和源码目录保持关系。

经常看到有人这样使用 cmake 配置项目：

```shell
cmake .
```

这句命令的意思是在当前目录运行 cmake 配置进行项目构建，这就等价于：

```shell
cmake -S . -B .
```

显然是源码目录和构建目录相同，构建输出文件会和源码文件混淆在一起，所以要避免。

我一直推荐的做法是这样：

```shell
cmake -S . -B build
```

有没有一种办法，能够在进行配置的时候，如果发现源码目录和构建目录相同就停止构建呢？其实很简单，使用前面讲过的 message() 命令就可以实现：

```cmake
if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
    message(FATAL_ERROR
      "\n"
      "In-source builds are not allowed.\n"
      "Instead, provide a path to build tree like so:\n"
      "cmake -S . -B <destination>\n"
      "\n"
      "To remove files you accidentally created execute:\n"
      "please delete CMakeFiles and CMakeCache.txt\n"
    )
endif()
```

这里的做法不算优雅，因为即使退出处理了，但还是会在源码目录产生一些构建文件，例如：CMakeFiles 和 CMakeCache.txt ，但目前也没有更好的办法。

### 3.5. 指定 C++ 标准

我们可以单独在某个 target 上指定 C++ 标准，使用如下形式：

```cmake
set_property(TARGET <target> PROPERTY CXX_STANDARD <standard>)
```

但是为了整个项目的统一，还是建议在顶级 CMakeLists.txt 中统一指定，如果有需要单独指定 C++ 版本的，再使用上面的形式：

```cmake
set(CMAKE_CXX_STANDARD 17)             # 指定使用 C++17 标准
set(CMAKE_CXX_STANDARD_REQUIRED ON)    # 必须满足指定的 C++ 标准
set(CMAKE_CXX_EXTENSIONS OFF)          # 关闭各个编译器自己拓展的特性，只使用 C++ 标准支持的特性
```

### 3.6. 定义目标

#### 3.6.1 定义目标的命令

- add_executable()

  ```cmake
  add_executable(<name> [WIN32] [MACOSX_BUNDLE]
                 [EXCLUDE_FROM_ALL]
                 [source1] [source2 ...])
  ```

  ```cmake
  add_executable(<name> IMPORTED [GLOBAL])
  ```

  ```cmake
  add_executable(<name> ALIAS <target>)
  ```

  TODO: 添加详细说明

- add_library()

  ```cmake
  add_library(<name> [STATIC | SHARED | MODULE]
              [EXCLUDE_FROM_ALL]
              [<source>...])
  ```

  ```cmake
  add_library(<name> OBJECT [<source>...])
  ```

  ```cmake
  add_library(<name> INTERFACE)
  ```

  ```cmake
  add_library(<name> INTERFACE [<source>...] [EXCLUDE_FROM_ALL])
  ```

  ```cmake
  add_library(<name> <type> IMPORTED [GLOBAL])
  ```

  ```cmake
  add_library(<name> ALIAS <target>)
  ```

  TODO: 添加详细说明

- add_custom_target()

  ```cmake
  add_custom_target(Name [ALL] [command1 [args1...]]
                    [COMMAND command2 [args2...] ...]
                    [DEPENDS depend depend depend ... ]
                    [BYPRODUCTS [files...]]
                    [WORKING_DIRECTORY dir]
                    [COMMENT comment]
                    [JOB_POOL job_pool]
                    [VERBATIM] [USES_TERMINAL]
                    [COMMAND_EXPAND_LISTS]
                    [SOURCES src1 [src2...]])
  ```

  TODO: 添加详细说明

#### 3.6.2. 目标依赖关系

一个成熟的项目，往往是由无数个组件构成，而各个组件之间会有依赖关系。所以组织代码结构就是在如何细分组件以及组织这些组件之间的依赖关系。

先来看一个没有外部组件，全部组件都属于当前项目的一个代码结构是如何组织的。

<img src=".assets/Figure_4.1_B17205-20220821202700473.jpg" alt="Figure 4.1 – Order of building dependencies in the BankApp project " style="zoom: 75%;" />

如上图，一共有 5 个 target 组件，它们之间的依赖关系如箭头所示。CMakeLists.txt 如下：

```cmake
cmake_minimum_required(VERSION 3.24)

project(BankApp CXX)

add_executable(terminal_app terminal_app.cpp)
target_link_libraries(terminal_app calculations)

add_executable(gui_app gui_app.cpp)
target_link_libraries(gui_app calculations drawing)

add_library(calculations calculations.cpp)
add_library(drawing drawing.cpp)

add_custom_target(checksum ALL
    COMMAND sh -c "cksum terminal_app > terminal.ck"
    COMMAND sh -c "cksum gui_app > gui.ck"
    BYPRODUCTS terminal.ck gui.ck
    COMMENT "Checking the sums..."
)
add_dependencies(checksum terminal_app gui_app)
```

#### 3.6.3. 目标属性

CMake 为各种类型的目标定义了许多默认的属性，可以参考官方文档。当然用户也可以为目标自定义属性以及获取属性的值，命令如下：

```cmake
get_target_property(<VAR> target property)
set_target_properties(target1 target2 ...
                      PROPERTIES prop1 value1
                      prop2 value2 ...)
```

- Tips

  - CMake 不光 target 有属性的概念，对于 GLOBA, DIRECTORY, SOURCE, INSTAL,TEST, 和 CACHE 均有属性的概念

  - 建议使用带 target 的命令设置和获取属性，当然不是 target 的时候也可以使用更低级的命令实现

    ```cmake
    get_property(<variable>
                 <GLOBAL             |
                  DIRECTORY [<dir>]  |
                  TARGET    <target> |
                  SOURCE    <source>
                            [DIRECTORY <dir> | TARGET_DIRECTORY <target>] |
                  INSTALL   <file>   |
                  TEST      <test>   |
                  CACHE     <entry>  |
                  VARIABLE           >
                 PROPERTY <name>
                 [SET | DEFINED | BRIEF_DOCS | FULL_DOCS])
                 
    set_property(<GLOBAL                      |
                  DIRECTORY [<dir>]           |
                  TARGET    [<target1> ...]   |
                  SOURCE    [<src1> ...]
                            [DIRECTORY <dirs> ...]
                            [TARGET_DIRECTORY <targets> ...] |
                  INSTALL   [<file1> ...]     |
                  TEST      [<test1> ...]     |
                  CACHE     [<entry1> ...]    >
                 [APPEND] [APPEND_STRING]
                 PROPERTY <name> [<value1> ...])
    ```

- 属性传播

  - PRIVATE
  - PUBLIC
  - INTERFACE

- 属性兼容性

  - TODO

#### 3.6.4. 伪目标

伪目标是指那种不会进行构建的目标。

- 导入目标

- 别名目标

  ```cmake
  add_executable(<name> ALIAS <target>)
  add_library(<name> ALIAS <target>)
  ```

- 接口库

  - 仅头文件库

  - 将一堆需要传播的属性捆绑到一个逻辑 target 中

    ```cmake
    add_library(warning_props INTERFACE)
    target_compile_options(warning_props
    		INTERFACE 
      			-Wall -Wextra -Wpedantic
    ) 
    target_link_libraries(executable warning_props)
    ```

### 3.7. 用户自定义命令

- 生成其他目标需要的源文件
- 将其他语言翻译成 C++
- 在其他目标构建前后执行特定任务

```cmake
add_custom_command(OUTPUT output1 [output2 ...]
                   COMMAND command1 [ARGS] [args1...]
                   [COMMAND command2 [ARGS] [args2...] ...]
                   [MAIN_DEPENDENCY depend]
                   [DEPENDS [depends...]]
                   [BYPRODUCTS [files...]]
                   [IMPLICIT_DEPENDS <lang1> depend1
                                    [<lang2> depend2] ...]
                   [WORKING_DIRECTORY dir]
                   [COMMENT comment]
                   [DEPFILE depfile]
                   [JOB_POOL job_pool]
                   [VERBATIM] [APPEND] [USES_TERMINAL]
                   [COMMAND_EXPAND_LISTS])
```

如上是用户自定义命令的其中一种形式，用户自定义目标不会创建一个逻辑上的 target，但是他的行为比较像 target，会加入到 target 依赖关系图中（将用户自定义命令的输出作为其他 target 的依赖，或者使用 DEPENDS 关键字）。

- 例子1：

  - person.proto

  ```c++
  message Person {
      required string name = 1;
      required int32 id = 2;
      optional string email = 3;
  }
  ```

  - CMakeLists.txt

  ```cmake
  add_custom_command(OUTPUT person.pb.h person.pb.cc
          COMMAND protoc ARGS person.proto
          DEPENDS person.proto
  )
  ```

- 例子2:

  ```cmake
  add_executable(main main.cpp constants.h)
  target_include_directories(main
  		PRIVATE
    			${CMAKE_BINARY_DIR}
  )
  
  add_custom_command(OUTPUT constants.h 
  		COMMAND cp ARGS "${CMAKE_SOURCE_DIR}/template.xyz" constants.h
  )

```cmake
add_custom_command(TARGET <target>
                   PRE_BUILD | PRE_LINK | POST_BUILD
                   COMMAND command1 [ARGS] [args1...]
                   [COMMAND command2 [ARGS] [args2...] ...]
                   [BYPRODUCTS [files...]]
                   [WORKING_DIRECTORY dir]
                   [COMMENT comment]
                   [VERBATIM] [USES_TERMINAL]
                   [COMMAND_EXPAND_LISTS])
```

上述用户自定义命令形式可以实现在构建一个目标之前或者之后执行一系列命令，这个非常的实用。

- PRE_BUILD
  - 只适用于 Visual Studio 生成器，如果是其他生成器，则相当于 PRE_LINK。
-  PRE_LINK
  - 在编译完成，链接之前运行命令，用户自定义目标不适用
- POST_BUILD
  - 改目标的其他命令都执行完了才执行的命令

使用这种形式可以将之前计算哈希值的例子：

```cmake
add_custom_target(checksum ALL
    COMMAND sh -c "cksum terminal_app > terminal.ck"
    COMMAND sh -c "cksum gui_app > gui.ck"
    BYPRODUCTS terminal.ck gui.ck
    COMMENT "Checking the sums..."
)
```

优化成：

```cmake
cmake_minimum_required(VERSION 3.24)
project(Command CXX)
add_executable(main main.cpp)
add_custom_command(TARGET main POST_BUILD
                   COMMAND cksum ARGS "$<TARGET_FILE:main>" > "main.ck"
)
```

### 3.8. 理解生成器表达式

在配置阶段，我们常常遇到先有鸡还是先有蛋的问题，一个目标依赖另一个目标输出的文件，但是在配置阶段这些信息是获取不到的，只有等配置阶段完成才可能知道。所以在配置阶段可以使用占位符代替这些依赖信息，等到生成阶段再去替换成实际的信息，这就是生成器表达式存在的意义。

调试生成器表达式的方法：

- 利用 file() 命令

  ```cmake
  file(GENERATE OUTPUT filename CONTENT "$<...>")
  ```

- 利用用户自定义目标

  ```cmake
  add_custom_target(gendbg COMMAND ${CMAKE_COMMAND} -E echo "$<...>")
  ```

#### 3.8.1. 生成器表达式语法

![Figure 4.4 – The syntax of a generator expression ](.assets/Figure_4.4_B17205.jpg)

- 如果有参数，则先写一个冒号，然后是参数，多个参数用逗号隔开。也就是说存在没有参数的生成器表达式，形式如下：

  ```cmake
  $<EXPRESSION>
  ```

- 生成器表达式支持嵌套，例如：

  ```cmake
  $<UPPER_CASE:$<PLATFORM_ID>>
  ```

- 生成器表达式中还可以取变量的值，例如：

  ```cmake
  $<UPPER_CASE:${my_variable}>
  ```

  值得注意的是，生成器表达式中的变量在配置阶段评估。

- 生成器表达式支持条件表达式

  ```cmake
  $<IF:condition,true_string,false_string>
  $<condition:true_string >
  ```

  ```cmake
  $<$<AND:$<COMPILE_LANGUAGE:CXX>,$<CXX_COMPILER_ID:AppleClang,Clang>>:COMPILING_CXX_WITH_CLANG>
  ```

生成器表达式被评估为两种类型：

- bool 类型：1、0

  ```cmake
  $<NOT:arg>
  $<AND:arg1,arg2,arg3...>
  $<OR:arg1,arg2,arg3...>
  $<BOOL:string_arg>
  
  # 除了空字符串，0, FALSE, OFF, N, NO, IGNORE, NOTFOUND，-NOTFOUND 结尾的字符串被评估为假，其他均评估为真
  
  $<STREQUAL:arg1,arg2>
  $<EQUAL:arg1,arg2>
  $<IN_LIST:arg,list>
  $<VERSION_EQUAL:v1,v2>
  $<VERSION_LESS:v1,v2>
  $<VERSION_GREATER:v1,v2>
  $<VERSION_LESS_EQUAL:v1,v2>
  $<VERSION_GREATER_EQUAL:v1,v2>
  
  $<TARGET_EXISTS:arg>
  
  $<CONFIG:args> # 当前配置是否在 args 中
  $<PLATFORM_ID:args>
  $<LANG_COMPILER_ID:args>
  $<COMPILE_FEATURES:features> # 编译器是否支持 features
  
  $<COMPILE_LANG_AND_ID:lang,compiler_id1,compiler_id2...>
  $<LINK_LANG_AND_ID:lang,compiler_id1,compiler_id2...>
  
  $<COMPILE_LANGUAGE:args>
  $<LINK_LANGUAGE:args>
  ```

  ```cmake
  target_compile_definitions(myapp
  		PRIVATE 
   				$<$<COMPILE_LANG_AND_ID:CXX,AppleClang,Clang>:CXX_CLANG>
   				$<$<COMPILE_LANG_AND_ID:CXX,Intel>:CXX_INTEL>
   				$<$<COMPILE_LANG_AND_ID:C,Clang>:C_CLANG>
  )
  
  target_compile_options(myapp
    	PRIVATE
    			$<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
  )
  ```

  

- 字符串类型

  ```cmake
  $<CONFIG> # Debug Release
  $<PLATFORM_ID> # Linux, Windows, or Darwin
  $<LANG_COMPILER_ID>
  $<COMPILE_LANGUAGE>
  $<LINK_LANGUAGE>
  
  $<TARGET_NAME_IF_EXISTS:target>
  
  $<TARGET_FILE:target>
  $<TARGET_FILE_NAME:target>
  $<TARGET_FILE_BASE_NAME:target>
  $<TARGET_FILE_PREFIX:target>
  $<TARGET_FILE_SUFFIX:target> #.so, .exe
  $<TARGET_FILE_DIR:target>
  
  $<TARGET_LINKER_FILE:target>
  $<TARGET_LINKER_FILE_NAME:target>
  $<TARGET_LINKER_FILE_BASE_NAME:target>
  $<TARGET_LINKER_FILE_PREFIX:target>
  $<TARGET_LINKER_FILE_SUFFIX:target>
  $<TARGET_LINKER_FILE_DIR:target>
  
  $<TARGET_SONAME_FILE:target>
  $<TARGET_SONAME_FILE_NAME:target>
  $<TARGET_SONAME_FILE_DIR:target>
  
  $<TARGET_PDB_FILE:target>
  $<TARGET_PDB_FILE_BASE_NAME:target>
  $<TARGET_PDB_FILE_NAME:target>
  $<TARGET_PDB_FILE_DIR:target>.
  
  $<TARGET_BUNDLE_DIR:target>
  $<TARGET_BUNDLE_CONTENT_DIR:target> 
  $<TARGET_PROPERTY:target,prop>
  $<TARGET_PROPERTY:prop>
  $<INSTALL_PREFIX>
  
  $<ANGLE-R> # > 符号
  $<COMMA> # 逗号
  $<SEMICOLON> # 冒号
  
  $<JOIN:list,d>
  $<REMOVE_DUPLICATES:list>
  $<FILTER:list,INCLUDE|EXCLUDE,regex>
  $<LOWER_CASE:string>
  $<UPPER_CASE:string>
  $<GENEX_EVAL:expr>
  $<TARGET_GENEX_EVAL:target,expr>
  
  $<LINK_ONLY:deps>
  $<INSTALL_INTERFACE:content> # returns content if used with install(EXPORT)
  $<BUILD_INTERFACE:content> # returns content if used with an export() command or by another target in the same buildsystem
  
  $<MAKE_C_IDENTIFIER:input>
  $<SHELL_PATH:input>
  
  $<TARGET_OBJECTS:target>
  ```

  ```cmake
  target_compile_options(tgt
  		$<$<CONFIG:DEBUG>:-ginline-points>
  )
  
  if (${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
       target_compile_definitions(myProject PRIVATE LINUX=1)
  endif()
  target_compile_definitions(myProject
  		PRIVATE
    			$<$<CMAKE_SYSTEM_NAME:LINUX>:LINUX=1>
  )
  
  add_library(enable_rtti INTERFACE)
  target_compile_options(enable_rtti
  		INTERFACE
    			$<$<OR:$<COMPILER_ID:GNU>,$<COMPILER_ID:Clang>>:-rtti>
  )
  ```

  

  







