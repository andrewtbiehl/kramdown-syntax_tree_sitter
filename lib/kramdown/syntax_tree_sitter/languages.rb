# frozen_string_literal: true

module Kramdown
  module Converter
    module SyntaxHighlighter
      module TreeSitter
        # Maps each recognized language alias to its corresponding Tree-sitter scope
        LANGUAGE_SCOPES =
          {
            'source.R' => %w[R S r s],
            'source.bash' => %w[bash ksh sh shell zsh],
            'source.c' => %w[c],
            'source.cpp' => %w[c++ cpp],
            'source.cs' => %w[c# cs csharp],
            'source.css' => %w[css],
            'source.d' => %w[d dlang],
            'source.dot' => %w[dot],
            'source.elixir' => %w[elixir exs],
            'source.elm' => %w[elm],
            'source.emacs.lisp' => %w[elisp emacs-lisp],
            'source.go' => %w[go golang],
            'source.hack' => %w[hack hh],
            'source.haskell' => %w[haskell hs],
            'source.hcl' => %w[hcl],
            'source.java' => %w[java],
            'source.js' => %w[javascript js],
            'source.json' => %w[json],
            'source.julia' => %w[jl julia],
            'source.lua' => %w[lua],
            'source.mk' => %w[bsdmake gnumake make makefile mf],
            'source.nix' => %w[nix nixos],
            'source.objc' => %w[obj-c obj_c objc objective_c objectivec],
            'source.ocaml' => %w[ocaml],
            'source.perl' => %w[perl pl],
            'source.php' => %w[php php3 php4 php5],
            'source.proto' => %w[proto protobuf],
            'source.python' => %w[py python],
            'source.racket' => %w[racket],
            'source.ruby' => %w[rb ruby],
            'source.rust' => %w[rs rust],
            'source.scala' => %w[scala],
            'source.sparql' => %w[sparql],
            'source.sql' => %w[sql],
            'source.swift' => %w[swift],
            'source.toml' => %w[toml],
            'source.ts' => %w[ts typescript],
            'source.vhd' => %w[vhdl],
            'source.html' => %w[html],
            'text.html.erb' => %w[erb eruby rhtml]
          }
          .map { |scope, aliases| aliases.map { |alias_| [alias_, scope] } }
          .flatten(1)
          .to_h
          .freeze
      end
    end
  end
end
