class IndexTemplate {
  String indexTemplate = """
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="description" content="@blogDetailKey@">
        <meta name="author" content="@userNameKey@">
        <link rel="shortcut icon" href="@blogLogoKey@" type="image/x-icon" />
        <title>@blogTitleKey@</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/semantic-ui@2.4.2/dist/semantic.min.css">
        <script src="https://code.jquery.com/jquery-3.6.0.slim.min.js" integrity="sha256-u7e5khyithlIdTpu22PHhENmPcRdFiHRjhAuHcs05RI=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/semantic-ui@2.4.2/dist/semantic.min.js"></script>
        <style type="text/css">

            .hidden.menu {
              display: none;
            }
        
            .masthead.segment {
              min-height: 700px;
              padding: 1em 0em;
            }
            .masthead .logo.item img {
              margin-right: 1em;
            }
            .masthead .ui.menu .ui.button {
              margin-left: 0.5em;
            }
            .masthead h1.ui.header {
              margin-top: 3em;
              margin-bottom: 0em;
              font-size: 4em;
              font-weight: normal;
            }
            .masthead h2 {
              font-size: 1.7em;
              font-weight: normal;
            }
        
            .ui.vertical.stripe {
              padding: 8em 0em;
            }
            .ui.vertical.stripe h3 {
              font-size: 2em;
            }
            .ui.vertical.stripe .button + h3,
            .ui.vertical.stripe p + h3 {
              margin-top: 3em;
            }
            .ui.vertical.stripe .floated.image {
              clear: both;
            }
            .ui.vertical.stripe p {
              font-size: 1.33em;
            }
            .ui.vertical.stripe .horizontal.divider {
              margin: 3em 0em;
            }
        
            .quote.stripe.segment {
              padding: 0em;
            }
            .quote.stripe.segment .grid .column {
              padding-top: 5em;
              padding-bottom: 5em;
            }
        
            .footer.segment {
              padding: 5em 0em;
            }
        
            .secondary.pointing.menu .toc.item {
              display: none;
            }
        
            @media only screen and (max-width: 700px) {
              .ui.fixed.menu {
                display: none !important;
              }
              .secondary.pointing.menu .item,
              .secondary.pointing.menu .menu {
                display: none;
              }
              .secondary.pointing.menu .toc.item {
                display: block;
              }
              .masthead.segment {
                min-height: 350px;
              }
              .masthead h1.ui.header {
                font-size: 2em;
                margin-top: 1.5em;
              }
              .masthead h2 {
                margin-top: 0.5em;
                font-size: 1.5em;
              }
            }
        </style>
    </head>
    <body>
        <!-- Following Menu -->
        <div class="ui large top fixed hidden menu">
            <div class="ui container">
                <a class="active item">主页</a>
                <a class="item">帖子</a>
                <a class="item">关于我</a>
            </div>
        </div>
        <!-- Sidebar Menu -->
        <div class="ui vertical inverted sidebar menu">
            <a class="active item">主页</a>
            <a class="item">帖子</a>
            <a class="item">关于我</a>
        </div>
        <!-- Page Contents -->
        <div class="pusher">
            <div class="ui inverted vertical masthead center aligned segment">
        
            <div class="ui container">
                <div class="ui large secondary inverted pointing menu">
                <a class="toc item">
                    <i class="sidebar icon"></i>
                </a>
                <a class="active item">主页</a>
                <a class="item">帖子</a>
                <a class="item">关于我</a>
                </div>
            </div>
        
            <div class="ui text container">
                <h1 class="ui inverted header">
                    @blogTitleKey@
                </h1>
                <h2>@blogDetailKey@</h2>
            </div>
        
            </div>
        
            <div class="ui vertical stripe segment">
            <div class="ui middle aligned stackable grid container">
                <div class="row">
                <div class="eight wide column">
                    <h3 class="ui header">最后一篇帖子</h3>
                    <p>最好一篇帖子的内容。最好一篇帖子的内容。最好一篇帖子的内容。最好一篇帖子的内容。最好一篇帖子的内容。最好一篇帖子的内容。...写错了，这个应该是最后一篇帖子的内容。</p>
                    <a class="ui primary button">查看全文</a>
                </div>
                <div class="six wide right floated column">
                    <img src="assets/images/wireframe/white-image.png" class="ui large bordered rounded image">
                </div>
                </div>
                <div class="row">
                <div class="center aligned column">
                    <a class="ui huge button">查看所有帖子</a>
                </div>
                </div>
            </div>
            </div>
        
        
            <div class="ui vertical stripe quote segment">
            <div class="ui equal width stackable internally celled grid">
                <div class="center aligned row">
                <div class="column">
                    <h3>@userNameKey@</h3>
                    <p>Author for this blog</p>
                </div>
                <div class="column">
                    <h3>"@userDetailKey@"</h3>
                    <p>
                    <img src="@userAvatarKey@" class="ui avatar image">
                    </p>
                </div>
                </div>
            </div>
            </div>
        
            <div class="ui vertical stripe segment">
            <div class="ui text container">
                <h3 class="ui header">这里放点简介会不会好点？</h3>
                <p>然后这里是简介的详情内容。不过如果遇到图片怎么办？好像遇到图片就显示不全了。</p>
                <a class="ui large button">查看全文</a>
                <h4 class="ui horizontal header divider">
                <a href="#">这里放点啥呢？</a>
                </h4>
                <h3 class="ui header">不清楚要放啥</h3>
                <p>这要怎么搞？删掉好像也不好看呀，唉，真的不会写html页面啊</p>
                <a class="ui large button">这里还有一个按钮</a>
            </div>
            </div>
        
        
            <div class="ui inverted vertical footer segment">
            <div class="ui container">
                <div class="ui stackable inverted divided equal height stackable grid">
                <div class="three wide column">
                    <h4 class="ui inverted header">关于</h4>
                    <div class="ui inverted link list">
                    <a href="https://semantic-ui.com/" target="_blank" class="item">Power by Semantic UI</a>
                    <a href="https://semantic-ui.com/examples/homepage.html" target="_blank" class="item">修改自Semantic UI的demo</a>
                    <a href="#" class="item">@blogCopyrightKey@</a>
                    <a href="#" class="item">@blogRecordKey@</a>
                    </div>
                </div>
                <div class="three wide column">
                    <h4 class="ui inverted header">这里可以放很多链接呢</h4>
                    <div class="ui inverted link list">
                    <a href="#" class="item">要不放个微博？</a>
                    <a href="#" class="item">或者来个邮箱？</a>
                    <a href="#" class="item">微信如果要放该怎么办？</a>
                    <a href="#" class="item">这怎么玩</a>
                    </div>
                </div>
                <div class="seven wide column">
                    <h4 class="ui inverted header">底部应该要写点啥的</h4>
                    <p>不知道写啥</p>
                </div>
                </div>
            </div>
            </div>
        </div>
    </body>
</html>
  """;
}
