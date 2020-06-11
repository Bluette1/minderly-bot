# minderly-bot

This is a capstone project at the end of the main Ruby curriculum at [Microverse](https:www.microverse.org/) - @microverseinc.

![demopage](./public/images/screenshot.png)

## Built With

- Ruby 

## Description
- This is a date checker. It keeps track of all your important events, such as birthdays, anniversaries, etc and sends out message notifications.
- It also sends out RSS feeds to subscribed users and channels.

- The [Telegram Bot Api](https://core.telegram.org/bots/api) was used to build this project.

## Live Demo

[Live Demo]()

### Run instructions 
-  You can clone the GitHub repo and type `ruby ./bin/bot_runner.rb` in the terminal to run the bot locally. Alternatively, you can create an executable script to run it.
- To add the bot to Telegram, one has to create a Telegram bot account for it using BotFather, and connect to it using the API obtained token.

### How to use the bot
Make sure the bot is running
- In order to use MinderlyBot one has to have a Telegram account.
- Ordinary users are able to interact with the bot via their Telegram accounts
- The bot is also able to post messages to channels and groups if it is added as an administrator.

### Available commands
- Please enter any of the following commands: ["/start", "/help", "/stop", "/add_my_birthday", "/add_birthday", "/add_anniversary", "/subscribe", "/update"]

### Possible errors
- Incorrect entry for date:
"Nick: 769887/22/98"
- Bot Response:
"invalid date: Incorrect format for birthday date entry."
- Make sure you enter the date in the proposed format.
- Correct entries for date
    - "12/06/1993" for "/add_my_birthday"
    - "Jenny: 10/05/1998" for "/add_birthday"
    - "Megan and John: 12/06/2011" for "/add_"

## Authors

👤 **Marylene Sawyer**
- Github: [@Bluette1](https://github.com/Bluette1)
- Twitter: [@MaryleneSawyer](https://twitter.com/MaryleneSawyer)
- Linkedin: [Marylene Sawyer](https://www.linkedin.com/in/marylene-sawyer-b4ba1295/)


# Acknowledgements
- [Creating a Bot using the Telegram Bot API](https://tutorials.botsfloor.com/creating-a-bot-using-the-telegram-bot-api-5d3caed3266d#.13ywsygju)

- There are great samples at [this site](https://core.telegram.org/bots/samples)
- To read more about RSS feeds visit [this Medium site](https://medium.com/@krandles/rss-and-ruby-its-really-simple-a32a8654733a)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check the [issues page](https://github.com/Bluette1/minderly-bot/issues).

## Show your support

Give a ⭐️ if you like this project!

## 📝 License

This project is [MIT](https://opensource.org/licenses/MIT) licensed.
