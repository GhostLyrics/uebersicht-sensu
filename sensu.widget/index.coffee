SENSU_PASSWORD = "password"
SENSU_USERNAME = "username"
SENSU_URL = "https://sensu.domain.example:port"

# display options
SORT_BY_HOSTNAME = true
SHOW_COMMAND = false
SHOW_OUTPUT = true

# blink indicators - possible values: "warn", "error", "unknown"
# e.g. BLINKING_INDICATORS = ["warn", "error"]
BLINKING_INDICATORS = []

command: "curl -sS --user #{SENSU_USERNAME}:#{SENSU_PASSWORD} #{SENSU_URL}/events"
refreshFrequency: 60000  # Milliseconds between calls


render: -> """
<div>
  <table></table>
  <style>
    @-webkit-keyframes blink {
       from { opacity: 1; }
       to { opacity: 0.2; }
    }
  </style>

</div>
"""

update: (output, domEl) ->
  # Redraw the widget
  events = JSON.parse(output)
  table = $(domEl).find('table')

  table.html('')

  translateStatus = (code) ->
    # translate between text and Sensu/Nagios status codes
    if code == 0
      return "ok"
    if code == 1
      return "warn"
    if code == 2
      return "error"
    else
      return "unknown"

  showCommand = (check) ->
    # display the check command if enabled
    if check.command? and SHOW_COMMAND == true
      return "<= " + check.command
    else
      return ""

  showOutput = (check) ->
    # display the check output if enabled
    if check.output? and SHOW_OUTPUT == true
      return "=> " + check.output
    else
      return ""

  showBlinking = (status) ->
    # blink indicators if enabled
    if "warn" in BLINKING_INDICATORS and status == 1
      return "blink"
    if "error" in BLINKING_INDICATORS and status == 2
      return "blink"
    if "unknown" in BLINKING_INDICATORS and status != 0
      return "blink"
    else
      return ""

  insertNewline = () ->
    # dynamically insert a newline between check command and check output if both are enabled
    if SHOW_OUTPUT == true and SHOW_COMMAND == true
      return "<br>"
    else
      return ""

  sortByHostname = (a, b) ->
    # sort the results by hostname if enabled
    return a.client.name.localeCompare(b.client.name)

  renderEvent = (event) ->
    # render one event
    """
    <tr>
      <td class="status #{translateStatus(event.check.status)} #{showBlinking(event.check.status)}"><div class="disc"></div></td>
      <td class="sitename">#{event.client.name}</td>
      <td class="check">#{event.check.name} </td>
      <td class="impact">#{showCommand(event.check)}#{insertNewline()}#{showOutput(event.check)}\</td>
    </tr>
    """

  if SORT_BY_HOSTNAME == true
    results = events.sort(sortByHostname)

  for event in events
    table.append renderEvent(event)


style: """
top: 20px
left: 80px
right: 80px
color: #ffffff
margin: 0 auto
font-family: Helvetica Neue, Sans-serif
font-smoothing: antialias
font-weight: 300
font-size: 16px
line-height: 27px

td
  vertical-align:top

.status
  padding: 8px 9px 0 0

.sitename, .check
  padding: 0 20px 0 0

.disc
  width: 12px
  height: 12px
  border-radius: 50%

.warn .disc
  background-color: rgba(249,186,70,1)

.error .disc
  background-color: rgba(234,84,67,1)

.unknown .disc
  background-color: rgba(77,77,77,1)

.blink
  animation: blink 2s cubic-bezier(0.950, 0.050, 0.795, 0.035) infinite alternate
"""
