# mcmake
本仓库记录一些 CMake 例子和 CMake 语法规则，以及一些 cmake 命令行和 GUI 界面程序的使用。

如需交流，请移步微信公众号: eglinux

<img src="/Users/eg/file/code/github/mcmake/README.assets/image-20220803235838745.png" alt="公众号二维码" style="zoom:25%;" />

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

![image-20220804002020555](/Users/eg/file/code/github/mcmake/README.assets/image-20220804002020555.png)

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

  - ${ARGC}
  - ${ARGV}
  - ${ARG0}, ${ARG1}, ${ARG2}
  - ${ARGN}

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
