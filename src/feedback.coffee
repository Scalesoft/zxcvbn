scoring = require('./scoring')

feedback =
  default_feedback:
    warning: ''
    suggestions: [
      "Použijte pár neobvyklých slov, vyhněte se běžným frázím"
      "Nemusíte používat čísla, speciální znaky nebo velká písmena"
    ]

  get_feedback: (score, sequence) ->
    # starting feedback
    return @default_feedback if sequence.length == 0

    # no feedback if score is good or great.
    return if score > 2
      warning: ''
      suggestions: []

    # tie feedback to the longest match for longer sequences
    longest_match = sequence[0]
    for match in sequence[1..]
      longest_match = match if match.token.length > longest_match.token.length
    feedback = @get_match_feedback(longest_match, sequence.length == 1)
    extra_feedback = 'Přidejte jedno-dvě slova, neobvyklá jsou lepší'
    if feedback?
      feedback.suggestions.unshift extra_feedback
      feedback.warning = '' unless feedback.warning?
    else
      feedback =
        warning: ''
        suggestions: [extra_feedback]
    feedback

  get_match_feedback: (match, is_sole_match) ->
    switch match.pattern
      when 'dictionary'
        @get_dictionary_match_feedback match, is_sole_match

      when 'spatial'
        layout = match.graph.toUpperCase()
        warning = if match.turns == 1
          'Písmena v řadě na klávesnici jsou snadno uhodnutelná'
        else
          'Krátké vzory na klávesnici jsou snadno uhodnutelné'
        warning: warning
        suggestions: [
          'Zkuste delší vzor, s více „zatáčkami“'
        ]

      when 'repeat'
        warning = if match.base_token.length == 1
          'Opakování jako „aaa“ jsou snadno uhodnutelná'
        else
          'Opakování jako „abcabcabc“ jsou jen o trochu složitěji uhodnutelná než „abc“'
        warning: warning
        suggestions: [
          'Vyhněte se opakování slov a písmen'
        ]

      when 'sequence'
        warning: "Řady jako abc nebo 6543 jsou snadno uhodnutelné"
        suggestions: [
          'Vyhněte se souvislým řadám'
        ]

      when 'regex'
        if match.regex_name == 'recent_year'
          warning: "Nedávné letopočty jsou snadno uhodnutelné"
          suggestions: [
            'Vyhněte se nedávným letopočtům'
            'Vyhněte se letopočtům, které se vás týkají (narození vás nebo dětí apod.)'
          ]

      when 'date'
        warning: "Datumy jsou často snadno uhodnutelné"
        suggestions: [
          'Vyhněte se datům, které se vás týkají (narození vás nebo dětí apod.)'
        ]

  get_dictionary_match_feedback: (match, is_sole_match) ->
    warning = if -1 != match.dictionary_name.indexOf 'passwords'
      if is_sole_match and not match.l33t and not match.reversed
        if match.rank <= 10
          'Tohle je jedno z 10 nejpoužívanějších hesel'
        else if match.rank <= 100
          'Tohle je jedno ze 100 nejpoužívanějších hesel'
        else
          'Tohle je velmi běžné heslo'
      else if match.guesses_log10 <= 4
        'Vaše heslo je velmi podobné častému heslu'
    else if match.dictionary_name in ['english_wikipedia', 'czech_wikipedia']
      if is_sole_match
        'Samostatné slovo je snadno uhodnutelné'
    else if match.dictionary_name in ['surnames', 'male_names', 'female_names', 'cs_surnames_no_dia', 'cs_names_no_dia']
      if is_sole_match
        'Samotná jména a příjmení jsou snadno uhodnutelná'
      else
        'Běžná jména a příjmení jsou snadno uhodnutelná'
    else
      ''

    suggestions = []
    word = match.token
    if word.match(scoring.START_UPPER)
      suggestions.push "Velké písmeno na začátku moc nepomáhá"
    else if word.match(scoring.ALL_UPPER) and word.toLowerCase() != word
      suggestions.push "Heslo psané kapitálkami je uhádnutelné skoro stejně snadno jako normální"

    if match.reversed and match.token.length >= 4
      suggestions.push "Slova psaná pozpátku nejsou o moc bezpečnější než normální"
    if match.l33t
      suggestions.push "Předvídatelné záměny znaků jako '@' místo 'a' moc nepomáhají"

    result =
      warning: warning
      suggestions: suggestions
    result

module.exports = feedback
