<html>
<head>
	<title>{{title}}</title>
	<link rel="stylesheet" type="text/css" href="bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="highlight.css">
	<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
	<div class="container">
		<div class="row">
			<div class="col-sm-2"></div>
			<div class="col-sm-8">
				<h1>{{title}}</h1>
				<div id="links">
					<span class="link"><a href="http://about.eyalarubas.com">About & Contact</a></span>
					<span class="link"><a href="https://www.goodreads.com/review/list/7034243-eyal">Reading List</a></span>
				</div>
				<div id="post-entries">
					{{#_global._contexts}}
					<div class="post-entry">
						<span class="title"><a href="{{slug}}.html">{{title}}</a></span>
						<span class="date">{{date}}</span>
					</div>
					{{/_global._contexts}}
				</div>
			</div>
			<div class="col-sm-2"></div>
		</div>
	</div>
</body>
</html>