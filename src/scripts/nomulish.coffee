# Description
#   translate words into 'nomulish'
#
# Dependencies:
#   "request": "^2.37.0"
#   "cheerio": "^0.17.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot nomulish <words> [l{1-5}] - translate words into 'nomulish'
#
# Author:
#   emanon001 <emanon001@gmail.com>
#

request = require 'request'
cheerio = require 'cheerio'

module.exports = (robot) ->
  robot.respond /set\s+nomulish\s+counter\s+max$/i, (msg) ->
    robot.brain.set 'totalNomulishCount', 64
    msg.reply 'set counter 64'
  robot.respond /show\s+nomulish\s+counter$/i, (msg) ->
    msg.reply "value is " + (robot.brain.get('totalNomulishCount') || 'nil')
  robot.respond /nomulish\s+(.*?)$/i, (res) ->
    words = res.match[1]
    level = '4'
    request
      .post
        url: 'http://racing-lagoon.info/nomu/translate.php'
        form:
          before: words
          level: level
          trans_btn: true # 何でもよいので値を入れる
        , (e, _, body) ->
          if e?
            robot.logger.error e.message
            res.send 'failed translate'
            return
          $ = cheerio.load body
          nomulish = $('textarea[name=after]').val()
          res.send nomulish
  robot.hear /(.*)/i, (res) ->
    nomulishCount = robot.brain.get('totalNomulishCount') * 1 or 0
    if nomulishCount > 64
      robot.brain.set 'totalNomulishCount', 0
      words = res.match[0]
      level = '4'
      request
        .post
          url: 'http://racing-lagoon.info/nomu/translate.php'
          form:
            before: words
            level: level
            trans_btn: true # 何でもよいので値を入れる
          , (e, _, body) ->
            if e?
              robot.logger.error e.message
              res.send 'failed translate'
              return
            $ = cheerio.load body
            nomulish = $('textarea[name=after]').val()
            res.send nomulish
    else
      robot.brain.set 'totalNomulishCount', nomulishCount+1
