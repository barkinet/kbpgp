
fs = require 'fs'
{make_esc} = require 'iced-error'
armor = require '../lib/openpgp/armor'
util = require '../lib/util'

#=================================================================

class Runner
  constructor : ({@msgfile, @keyfile, @password}) ->

  _read_file : (fn, cb) ->
    esc = make_esc cb, "read_file #{fn}"
    await fs.readFile fn, esc defer data
    [err, msgs] = armor.mdecode data
    await util.athrow err, esc defer()
    console.log msgs
    cb null, msgs

  read_keys : (cb) ->
    esc = make_esc cb, "read_keys"
    await @_read_file @keyfile, esc defer msgs
    cb null

  read_msg : (cb) ->
    esc = make_esc cb, "read_msg"
    await @_read_file @msgfile, esc defer msgs
    cb null

  process : (cb) ->
    cb null

  run : (cb) ->
    esc = make_esc cb, "run"
    await @read_keys esc defer()
    await @read_msg esc defer()
    await @process esc defer()
    cb null

#=================================================================

argv = require('optimist').alias("m", "msg").alias("k","keyfile").alias("p","password").argv

runner = new Runner { msgfile : argv.m, keyfile : argv.k, password : argv.p }
await runner.run defer err
throw err if err?
process.exit0