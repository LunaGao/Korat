class IndexTemplate {
  String indexItemTemplate = """
<div class="container">
    <h1 class="display-6">@postTitleKey@</h1>
    <p class="lead">@postContentLongDesKey@</p>
    <a class="btn btn-primary" href="@postLinkKey@" role="button">查看全文</a>
</div>
<hr>
  """;

  String indexTemplate = """
<!DOCTYPE html>
<html lang="cn">
    <head>
        <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-1252972631413140" crossorigin="anonymous"></script>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="@blogDetailKey@">
        <meta name="author" content="@userNameKey@">
        <link rel="shortcut icon" href="@blogLogoKey@" type="image/x-icon" />
        <title>@blogTitleKey@</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
        <style>
            hr {
                margin-top: 4rem;
                margin-bottom: 4rem;
            }
        </style>
    </head>
    <body>
        <header>
            <nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark">
                <div class="container marketing">
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarCollapse">
                        <ul class="navbar-nav me-aut">
                            <li class="nav-item">
                                <a class="nav-link active" aria-current="page" href="index.html">主页</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" aria-current="page" href="posts.html">帖子</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" aria-current="page" href="about.html">关于我</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
        </header>
        <main>
            <div class="bg-dark text-center text-light marketing position-relative" style="height: 600px; margin-bottom: 4rem;">
                <div class="position-absolute top-50 start-50 translate-middle">
                    <h1 class="display-1">@blogTitleKey@</h1>
                    <h1 class="display-6">@blogDetailKey@</h1>
                    <a class="btn btn-outline-light" href="posts.html" role="button" style="margin-top: 2rem;">查看所有帖子</a>
                </div>
            </div>
            <div class="container marketing">
                @postListKey@
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col text-center">
                            <h1 class="display-6">@userNameKey@</h1>
                            <p class="lead">博客作者</p>
                        </div>
                        <div class="vr" style="width: 1px; padding : 0;"></div>
                        <div class="col text-center">
                            <h1 class="display-6">“@userDetailKey@”</h1>
                            <img class="rounded-circle" src="@userAvatarKey@" alt="头像" style="width: 40px;">
                        </div>
                    </div>
                </div>
                <hr>
                <div class="row text-center" style="margin-bottom: 4rem;">
                    <div class="container">
                        <h1 class="display-4">关于我</h1>
                        <p class="lead">关于我的简介哦，哇咔咔。关于我的简介哦，哇咔咔。关于我的简介哦，哇咔咔。关于我的简介哦，哇咔咔。关于我的简介哦，哇咔咔。关于我的简介哦，哇咔咔。关于我的简介哦，哇咔咔。关于我的简介哦，哇咔咔。关于我的简介哦，哇咔咔。</p>
                        <a class="btn btn-primary" href="about.html" role="button">查看全文</a>
                    </div>
                </div>
            </div>

            <footer class="text-light bg-dark">
                <div class="container marketing" style="padding-top: 4rem; padding-bottom: 6rem;">
                    <div class="row row-cols-auto">
                        <div class="col">
                            <h5>关于</h5>
                            <ul class="list-unstyled text-small">
                                <li><a class="link-secondary" href="https://getbootstrap.com/">Power by Bootstrap</a></li>
                                <li><a class="link-secondary" href="#">Generated from Korat</a></li>
                                <li><a class="link-secondary" href="#">@blogCopyrightKey@</a></li>
                                <li><p class="text-secondary">@blogRecordKey@</p></li>
                            </ul>
                        </div>
                        <div class="vr" style="width: 1px; padding: 0; margin-left: 4rem; margin-right: 2rem;"></div>
                        <div class="col">
                            <h5>更多链接</h5>
                            <ul class="list-unstyled text-small">
                                <li><a class="link-secondary" href="@socialWeiboKey@">微博</a></li>
                                <li><a class="link-secondary" href="@socialEmailKey@">邮箱</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </footer>
        </main>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ" crossorigin="anonymous"></script>
    </body>
</html>
  """;
}
