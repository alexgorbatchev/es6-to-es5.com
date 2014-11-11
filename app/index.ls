require! {
  \express
  \jade
  \compression
  \less-middleware
  \livescript-middleware
}

{PORT, NODE_ENV} = process.env
IS-PROD = NODE_ENV is \production

app = express!

less-options =
  dest  : "#{__dirname}/public"
  once  : IS-PROD
  force : not IS-PROD

livescript-options =
  src      : "#{__dirname}/scripts"
  dest     : "#{__dirname}/public"
  compress : IS-PROD
  force    : not IS-PROD

app.engine 'jade', jade.__express
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'
app.set 'view cache', IS-PROD

app.use compression!

app.use less-middleware "#{__dirname}/styles", less-options
app.use livescript-middleware livescript-options
app.use express.static "#{__dirname}/public"
app.use express.static "#{__dirname}/../bower_components"
app.use express.static "#{__dirname}/../vendor"

app.get '/', (req, res) ->
  res.render 'index'

app.listen PORT ? 3000

console.log 'Server running...'
