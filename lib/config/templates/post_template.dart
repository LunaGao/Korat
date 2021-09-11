class PostTemplate {
  String postTemplate = """
<!DOCTYPE html>
<html lang="cn">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="@blogDetailKey@">
        <meta name="author" content="@userNameKey@">
        <link rel="shortcut icon" href="@blogLogoKey@" type="image/x-icon" />
        <title>@postTitleKey@ - @blogTitleKey@</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
        <style>
            hr {
                margin-top: 1rem;
                margin-bottom: 1rem;
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
                                <a class="nav-link" aria-current="page" href="index.html">主页</a>
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
        <main style="margin-top: 6rem;">
            
            <div class="container marketing">
                <div class="p-4 p-md-5 mb-4 text-white rounded bg-danger">
                    <div class="col-md-6 px-0">
                        <h1 class="display-4 fst-italic">@postTitleKey@</h1>
                        <p class="lead my-3">@postTimeKey@</p>
                        <!-- <p class="lead mb-0"><a href="#" class="text-white fw-bold">这里放标签吧</a></p> -->
                    </div>
                </div>
                <div class="row g-5">
                    
                    <div class="col-md-9">

                        @content@

                        <!-- <nav class="blog-pagination" aria-label="Pagination" style="margin-top: 4rem; margin-bottom: 4rem;">
                            <a class="btn btn-outline-primary disabled" href="#">上一页</a>
                            <a class="btn btn-outline-primary" href="#">下一页</a>
                        </nav> -->
                
                    </div>
                
                    <div class="col-md-3">
                        <div class="position-sticky" style="top: 8rem;">
                            <div class="p-4 mb-3 bg-light rounded">
                                <p><img class="rounded-circle" src="@userAvatarKey@" alt="头像" style="width: 60px;"></p>
                                <h4 class="fst-italic">@userNameKey@</h4>
                                <p class="mb-0">@userDetailKey@</p>
                            </div>
                    
                            <div class="p-4">
                                <h4 class="fst-italic">Archives</h4>
                                <ol class="list-unstyled mb-0">
                                    <li><a href="#">March 2021</a></li>
                                    <li><a href="#">February 2021</a></li>
                                    <li><a href="#">January 2021</a></li>
                                    <li><a href="#">December 2020</a></li>
                                    <li><a href="#">November 2020</a></li>
                                    <li><a href="#">October 2020</a></li>
                                    <li><a href="#">September 2020</a></li>
                                    <li><a href="#">August 2020</a></li>
                                    <li><a href="#">July 2020</a></li>
                                    <li><a href="#">June 2020</a></li>
                                    <li><a href="#">May 2020</a></li>
                                    <li><a href="#">April 2020</a></li>
                                </ol>
                            </div>
                        </div>
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
