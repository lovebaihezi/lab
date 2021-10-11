(TeX-add-style-hook
 "data"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "a4paper")))
   (TeX-run-style-hooks
    "latex2e"
    "style/template"
    "article"
    "art10"
    "ctex")
   (LaTeX-add-labels
    "c"
    "overview"
    "sub:ptx"
    "sub:ptxproc"
    "fig:singleblock"
    "sub:ptxeva"
    "ptxvsx86"
    "sub:app.code")
   (LaTeX-add-bibitems
    "Erdos01"))
 :latex)

