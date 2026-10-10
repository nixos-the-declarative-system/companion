# camille’s notebook

An example Zola site that accompanies the book *NixOS: The
Declarative System*: two pages, no theme, deliberately minimal.

The book invites you to *adopt* it: cloned, then relieved of its
history, it becomes the content of your own repository, which your
`my-blog.nix` recipe packages. Without the book, this repository
reads like a skeleton: the book is what carries the context.

A detail of workmanship: `base_url = "/"`. Links are computed
root-relative, so the site works at any address that serves it from
its root.
