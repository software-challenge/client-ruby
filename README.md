# Software-Challenge Client

[![Gem version (Socha)](https://img.shields.io/gem/v/software_challenge_client)](https://rubygems.org/gems/software_challenge_client)
[![Discord](https://img.shields.io/discord/233577109363097601?color=blue&label=Discord)](https://discord.gg/ARZamDptG5)
[![Documentation](https://img.shields.io/badge/Software--Challenge%20-Documentation-%234299e1)](https://docs.software-challenge.de/)

This gem includes everything to build a client for the coding
competition [Software-Challenge](http://www.software-challenge.de).

------------------------------------------------------------------------

_Language:_ Most documentation will be in german language, because it is intended
to be used by pupils taking part in the Software-Challenge programming
competition. Only internal documentation is in english.

------------------------------------------------------------------------

_Sprache:_ Ein Grossteil der Dokumentation ist in deutscher Sprache verfasst, da
sie dazu gedacht ist, von am Programmierwettbewerb Software-Challenge
teilnehmenden Schülerinnen und Schülern gelesen zu werden. Interne Dokumentation
ist weiterhin in englisch.

------------------------------------------------------------------------

## Installation

Um die Software-Challenge Bibliothek in deinem Computerspieler zu verwenden, füge folgende Zeile in das Gemfile deines Projektes ein:

    $ gem 'software_challenge_client'

Installiere das Gem dann mit dem Befehl:

    $ bundle

Oder installiere das Gem ohne ein Gemfile mit:

    $ gem install software_challenge_client

## Verwendung

Ein Beispielprojekt zur Verwendung der Bibliothek findet man im Verzeichnis `example` ([Beispielprojekt auf GitHub](https://github.com/CAU-Kiel-Tech-Inf/socha_ruby_client/tree/master/example)).

Du kannst den Beispielclient mittels

    $ ruby main.rb

in einer Konsole ausführen (dazu musst du dich im Verzeichnis `example` befinden).

Damit dies funktioniert, muss das Gem bereits wie oben beschrieben installiert
sein und es muss ein Spielserver auf eine Verbindung warten (also zum Beispiel
ein Spiel mit einem manuell gestarteten Spieler in der grafischen Oberfläche
angelegt worden sein).

Neben Beiwerk wie dem Initialisieren der Verbindung zum Spielserver und
Verarbeiten der Startparameter (was beides in `main.rb` des Beispielprojektes
passiert), musst du nur eine Klasse implementieren, um einen lauffähigen
Computerspieler zu haben (`client.rb` im Beispielprojekt):

    require 'software_challenge_client'

    class Client < ClientInterface
      include Logging

      attr_accessor :gamestate

      def initialize(log_level)
        logger.level = log_level
        logger.info 'Einfacher Spieler wurde erstellt.'
      end

      # gets called, when it's your turn
      def move_requested
        logger.info "Spielstand: #{gamestate.points_for_player(gamestate.current_player)} - #{gamestate.points_for_player(gamestate.other_player)}"
        move = best_move
        logger.debug "Zug gefunden: #{move}" unless move.nil?
        move
      end

      def best_move
        GameRuleLogic.possible_moves(gamestate).sample
      end
    end

### Abgabe des Clients im SC Wettkampfsystem

Da Ruby eine interpretierte Sprache ist, muss der Ruby-Quellcode direkt
in ein ZIP-Archiv gepackt und auf das [Wettkampfsystem](https://docs.software-challenge.de/glossary/contest) hochgeladen
werden. Auf dem [Wettkampfsystem](https://docs.software-challenge.de/glossary/contest) ist ein Ruby-Interpreter sowie das
aktuellste `software_challenge_client` Gem installiert. Alle weiteren
Bibliotheken müssen im ZIP-Archiv vorhanden sein. Nach dem Hochladen des ZIP-Archivs muss die auszuführende Hauptdatei im [Wettkampfsystem](https://docs.software-challenge.de/glossary/contest)
ausgewählt werden. Diese wird dann zum Start des Computerspielers
gestartet. Damit dies richtig funktioniert, ist es entscheidend, dass
die Hauptdatei mit einer sogenannten "Shebang"-Zeile beginnt:

    #!/usr/bin/env ruby

Weiterhin ist es ratsam, den Magic-Comment zum Encoding direkt unter die
Shebang-Zeile zu schreiben:

    # encoding: UTF-8

Ein vollständiges Beispiel für einen abgabefertigen Ruby-Computerspieler
gibt es im [example Verzeichnis des Computerspieler-Gems bei
Github](https://github.com/software-challenge/client-ruby/tree/main/example).
Packt man die beiden Dateien `client.rb` und `main.rb` in ein
ZIP-Archiv, hat man einen abgabefertigen Computerspieler. Beim Hochladen
wählt man `main.rb` als Hauptdatei.

## Generating the Documentation

Code documentation can be generated using YARD in the project root (source code
needs to be checked out and `bundle` has to be executed,
see [Installation](#installation)):

    $ yard

After generation, the docs can be found in the `doc` directory. Start at
`index.html`.

Documentation for the latest source can also be found
on
[rubydoc.info](http://www.rubydoc.info/github/CAU-Kiel-Tech-Inf/socha_ruby_client).

When updating the docs, you may use

    $ yard server --reload

or inside a docker container

    $ yard server --reload --bind 0.0.0.0

to get a live preview of them at [http://localhost:8808](http://localhost:8808).

## Development

After checking out the repo, run `bin/setup` to install
dependencies. Then, run `rspec` to run the tests. You can also
run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `gem uninstall
software_challenge_client` to remove an existing gem and then `bundle exec rake
install` to install the current version.

To develop inside a docker container, make sure you have Docker installed and execute
`develop.sh`.

### Specs

The gem is tested using RSpec. To run all tests, execute `rspec`. When
developing, you may use Guard to execute tests when files change. To do this,
execute `guard`. Tests will then be automatically run when you change a file.

### Linting

Linting by rubocop is included in the guard config. It is run when all specs
pass.

### Releasing

To release a new version, update the version number in
`lib/software_challenge_client/version.rb` and update RELEASES.md.

Then run `bundle exec rake release`, which will create a git tag for the
version, push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org). You may also use the `release.sh` script
which executes `bundle exec rake release` in a suitable docker container.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/CAU-Kiel-Tech-Inf/socha_ruby_client. This project is intended
to be a safe, welcoming space for collaboration, and contributors are expected
to adhere to the [code of
conduct](https://github.com/CAU-Kiel-Tech-Inf/socha-client-ruby/blob/master/CODE_OF_CONDUCT.md)
(from [Contributor Covenant](http://contributor-covenant.org)).
