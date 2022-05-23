require File.expand_path('../config/environment',__dir__)

require 'telegram/bot'

token = "5196446847:AAG-uBuVE0MDig5dI2SNeyiJ6fz3zR1WtHY"
# bundle exec ruby bot.rb

Skale = ["Для мене як негативні, так і позитивні емоції служать джерелом знання про те, як чинити в житті.",
        "Негативні емоції допомагають мені зрозуміти, що я повинен змінити у своєму житті.",
        "Я здатний спостерігати зміну своїх почуттів.",
        "Я спокійний, коли відчуваю тиск з боку.",
        "Я стежу за тим, як я себе почуваю.",
        "Після того як щось засмутило мене, я можу легко впоратися зі своїми почуттями.",
        "Коли необхідно, я можу бути спокійним і зосередженим, щоб діяти відповідно до запитів життя.",
        "Коли необхідно, я можу викликати у себе широкий спектр позитивних емоцій, таких як веселощі, радість, внутрішній підйом і гумор.",
        "Я можу змусити себе знову і знову встати перед обличчям перешкоди.",
        "Я здатний вислуховувати проблеми інших людей.",
        "Я чутливий до емоційних потреб інших.",
        "Я добре розумію емоції інших людей, навіть якщо вони не виражені відкрито.",
        "Я можу діяти на інших людей заспокійливо.",
        "Я адекватно реагую на настрої, спонукання і бажання інших людей.",
        "Люди вважають мене добрим знавцем переживань інших."
    ]

 arr = ["_Повністю НЕ згоден🌑",
	"_В основному НЕ згоден🌒", 
	"_Частково НЕ згоден🌓", 
	"_Частково згоден🌖", 
	"_В основному згоден🌕",
	"_Повністю згоден☀️"
	]

points = 0
flag = 0

skale1 = 0
skale2 = 0
skale3 = 0
skale4 = 0
skale5 = 0

Telegram::Bot::Client.run(token) do |bot|
	bot.listen do |message|
		case message

		when Telegram::Bot::Types::CallbackQuery
			if message.data == 'kstart'
				points = 0
				flag = 0
				skale1 = 0
				skale2 = 0
				skale3 = 0
				skale4 = 0
				skale5 = 0
			     	bot.api.send_message(chat_id: message.from.id, text: " #{Skale[flag]}")
			    	flag = flag + 1
				markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: arr)
				   #one_time_keyboard: true
				bot.api.send_message(chat_id: message.from.id,text: "Вибирайте варіант, що найбільше вам підходить", reply_markup: markup)
                        end

                        if message.data == 'kstop'
                        	points = 0
				flag = 0
				skale1 = 0
				skale2 = 0
				skale3 = 0
				skale4 = 0
				skale5 = 0
                        	kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
				bot.api.send_message(chat_id: message.from.id, text: "Завершити!", reply_markup: kb)

				#НЕ ЗБЕРІГАЮТЬСЯ ДАНІ У ТАБЛИЦЮ
                        end

                        if message.data == 'kpause'
                        	flag = flag - 1
                        	kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
				bot.api.send_message(chat_id: message.from.id, text: "Пауза", reply_markup: kb)
				bot.api.send_message(chat_id: message.from.id, text: "Ви зупинились на #{flag} питанні.")
				kb = [
					Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Продовжити тест', callback_data: 'kcontin'),
					#ПРОДОВЖИТИ 

	                		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Завершити! Без збереження даних тесту', callback_data: 'kstop'),
	            		]
	            		markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
	            		bot.api.send_message(chat_id: message.from.id, text: 'Що обираєте?', reply_markup: markup)
                        end

                        if message.data == 'kcontin'
                        	bot.api.send_message(chat_id: message.from.id, text: " #{Skale[flag]}")
			    	flag = flag + 1
				markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: arr)
				   #one_time_keyboard: true
				bot.api.send_message(chat_id: message.from.id,text: "Вибирайте варіант, що найбільше вам підходить", reply_markup: markup)
                        end

                        if message.data == 'kinfo'
                        	bot.api.send_message(chat_id: message.from.id, text: "Методика призначена для виявлення здібності особистості розуміти відносини, що репрезентується в емоціях, і керувати своєю емоційною сферою на основі прийняття рішень. Вона складається з 15 тверджень.")
                        	bot.api.send_message(chat_id: message.from.id, text: "До кожного твердження підберіть відповідь, виходячи з вашого ступеня згоди з ним.")
                        	kb = [
					Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Почати тест', callback_data: 'kstart'),

	                		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Корисні поради', callback_data: 'kadvice'),
	                		#ВИВЕСТИ КІЛЬКА ЗАГАЛЬНИХ ПОРАД
	            		]
	            		markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
	            		bot.api.send_message(chat_id: message.from.id, text: 'Що обираєте?', reply_markup: markup)
                        end

                        if message.data == 'kdata'
                        	if points != 0 && flag != 0 && skale1 != 0 && skale2 != 0 && skale3 != 0 && skale4 != 0 && skale5 != 0
	                        	if !User.exists?(telegram_id:message.from.id)
	                                	user = User.create(name: message.from.first_name, telegram_id:message.from.id)
	                                	user.emolevels.create(scale1: skale1, scale2: skale2, scale3: skale3, scale4: skale4, scale5: skale5, emosum: points, time: 1)
	                                	bot.api.send_message(chat_id: message.from.id, text: "Ваші дані збережені!")
	                                else
	                                	user = User.find_by(telegram_id:message.from.id)            
	                                        previous = user.emolevels.last 
	                                        t = previous.time
	                                	t = t + 1
	                                	user.emolevels.create(scale1: skale1, scale2: skale2, scale3: skale3, scale4: skale4, scale5: skale5, emosum: points, time: t)
	                                	bot.api.send_message(chat_id: message.from.id, text: "Ваші дані збережені!")
	                                	bot.api.send_message(chat_id: message.from.id, text: "За попереднє проходження тестуваш прогрес був такий:")
						if previous.scale1 >= 8
		                        		bot.api.send_message(chat_id: message.from.id, text: "У вас високий рівень емоційної обізнаності")
		                        	end
		                        	if previous.scale1 >= 3 && previous.scale1 <= 7
		                        		bot.api.send_message(chat_id: message.from.id, text: "У вас середній рівень емоційної обізнаності")
		                        	end
		                        	if previous.scale1 <= 2
		                        		bot.api.send_message(chat_id: message.from.id, text: "У вас низький рівень емоційної обізнаності")
		                        	end

		                        	if previous.scale2 >= 8
		                        		bot.api.send_message(chat_id: message.from.id, text: "У вас високий рівень управління своїми емоціями")
		                        	end
		                        	if previous.scale2 >= 3 && previous.scale2 <= 7
		                        		bot.api.send_message(chat_id: message.from.id, text: "У вас середній рівень управління своїми емоціями")
		                        	end
		                        	if previous.scale2 <= 2
		                        		bot.api.send_message(chat_id: message.from.id, text: "У вас низький рівень управління своїми емоціями")
		                        	end

		                        	if previous.scale3 >= 8
		                        		bot.api.send_message(chat_id: message.from.id, text: "У вас високий рівень самомотивації")
		                        	end
		                        	if previous.scale3 >= 3 && previous.scale3 <= 7
		                        		bot.api.send_message(chat_id: message.from.id, text: "У вас середній рівень самомотивації")
		                        	end
		                        	if previous.scale3 <= 2
		                        		bot.api.send_message(chat_id: message.from.id, text: "У вас низький рівень самомотивації")
		                        	end

		                        	if previous.scale4 >= 8
		                        		bot.api.send_message(chat_id: message.from.id, text: "У вас високий рівень емпатії")
		                        	end
		                        	if previous.scale4 >= 3 && previous.scale4 <= 7
		                        		bot.api.send_message(chat_id: message.from.id, text: "У вас середній рівень емпатії")
		                        	end
		                        	if previous.scale4 <= 2
		                        		bot.api.send_message(chat_id: message.from.id, text: "У вас низький рівень емпатії")
		                        	end

		                        	if previous.scale5 >= 8
		                        		bot.api.send_message(chat_id: message.from.id, text: "У вас високий рівень розпізнання емоцій інших людей")
		                        	end
		                        	if previous.scale5 >= 3 && previous.scale5 <= 7
		                        		bot.api.send_message(chat_id: message.from.id, text: "У вас середній рівень розпізнання емоцій інших людей")
		                        	end
		                        	if previous.scale5 <= 2
		                        		bot.api.send_message(chat_id: message.from.id, text: "У вас низький рівень розпізнання емоцій інших людей")
		                        	end


					end  
				end	                            	
                        end


                        if message.data == 'skale_detail'
                        	bot.api.send_message(chat_id: message.from.id, text: "__________Детальніші дані по шкалам__________")

                        	if skale1 >= 8
                        		bot.api.send_message(chat_id: message.from.id, text: "У вас високий рівень емоційної обізнаності")
                        	end
                        	if skale1 >= 3 && skale1 <= 7
                        		bot.api.send_message(chat_id: message.from.id, text: "У вас середній рівень емоційної обізнаності")
                        	end
                        	if skale1 <= 2
                        		bot.api.send_message(chat_id: message.from.id, text: "У вас низький рівень емоційної обізнаності")
                        	end

                        	if skale2 >= 8
                        		bot.api.send_message(chat_id: message.from.id, text: "У вас високий рівень управління своїми емоціями")
                        	end
                        	if skale2 >= 3 && skale2 <= 7
                        		bot.api.send_message(chat_id: message.from.id, text: "У вас середній рівень управління своїми емоціями")
                        	end
                        	if skale2 <= 2
                        		bot.api.send_message(chat_id: message.from.id, text: "У вас низький рівень управління своїми емоціями")
                        	end

                        	if skale3 >= 8
                        		bot.api.send_message(chat_id: message.from.id, text: "У вас високий рівень самомотивації")
                        	end
                        	if skale3 >= 3 && skale3 <= 7
                        		bot.api.send_message(chat_id: message.from.id, text: "У вас середній рівень самомотивації")
                        	end
                        	if skale3 <= 2
                        		bot.api.send_message(chat_id: message.from.id, text: "У вас низький рівень самомотивації")
                        	end

                        	if skale4 >= 8
                        		bot.api.send_message(chat_id: message.from.id, text: "У вас високий рівень емпатії")
                        	end
                        	if skale4 >= 3 && skale4 <= 7
                        		bot.api.send_message(chat_id: message.from.id, text: "У вас середній рівень емпатії")
                        	end
                        	if skale4 <= 2
                        		bot.api.send_message(chat_id: message.from.id, text: "У вас низький рівень емпатії")
                        	end

                        	if skale5 >= 8
                        		bot.api.send_message(chat_id: message.from.id, text: "У вас високий рівень розпізнання емоцій інших людей")
                        	end
                        	if skale5 >= 3 && skale5 <= 7
                        		bot.api.send_message(chat_id: message.from.id, text: "У вас середній рівень розпізнання емоцій інших людей")
                        	end
                        	if skale5 <= 2
                        		bot.api.send_message(chat_id: message.from.id, text: "У вас низький рівень розпізнання емоцій інших людей")
                        	end

                        	kb = [
                        		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Зберегти дані та завершити', callback_data: 'kdata'),
	                		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Завершити! Без збереження даних тесту', callback_data: 'kstop'),
	            		]
	            		markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
	            		bot.api.send_message(chat_id: message.from.id, text: 'Що обираєте?', reply_markup: markup)
                        end

                        if message.data == 'kadvice'
                        	bot.api.send_message(chat_id: message.from.id, text: "__________Наші поради__________")
                        	bot.api.send_message(chat_id: message.from.id, text: "1.Пам’ятайте, що високий емоційний інтелект – це процес вашої праці протягом всього життя, його потрібно розвивати та вдосконалювати")
                        	bot.api.send_message(chat_id: message.from.id, text: "2.Навчіться довіряти вашій інтуїції.")
                        	bot.api.send_message(chat_id: message.from.id, text: "3.Не бійтеся просити про допомогу та допомагати іншим.")
                        	bot.api.send_message(chat_id: message.from.id, text: "4.Любіть себе, але при цьому не будьте егоїстом.")
                        	kb = [
					Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Почати тест', callback_data: 'kstart'),
	                		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Дізнатись більше про тест', callback_data: 'kinfo'),
	                		#ВИВЕСТИ МЕТОДИКУ ОЦІНЮВАННЯ
	            		]
	            		markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
	            		bot.api.send_message(chat_id: message.from.id, text: 'Що обираєте?', reply_markup: markup)
                        end

                        if message.data == 'kadvice_h'
                        	bot.api.send_message(chat_id: message.from.id, text: "__________Наші поради__________")
                        	bot.api.send_message(chat_id: message.from.id, text: "1.Подорожуйте та вивчайте інші культури і країни.")
                        	bot.api.send_message(chat_id: message.from.id, text: "2.Приділяйте увагу фізичним вправам та тому, що ви споживаете; не забувайте про збалансовану дієту.")
                        	bot.api.send_message(chat_id: message.from.id, text: "3.Ведіть щоденник емоцій.")
                        	bot.api.send_message(chat_id: message.from.id, text: "4.Не піддавайтеся впливу поганого настрою.")

                        	kb = [
                        		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Зберегти дані та завершити', callback_data: 'kdata'),
	                		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Завершити! Без збереження даних тесту', callback_data: 'kstop'),
	            		]
	            		markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
	            		bot.api.send_message(chat_id: message.from.id, text: 'Що обираєте?', reply_markup: markup)
                        end

                        if message.data == 'kadvice_m'
                        	bot.api.send_message(chat_id: message.from.id, text: "__________Наші поради__________")
                        	bot.api.send_message(chat_id: message.from.id, text: "1.Любіть себе, але при цьому не будьте егоїстом.")
                        	bot.api.send_message(chat_id: message.from.id, text: "2.Не бійтеся просити про допомогу та допомагати іншим.")
                        	bot.api.send_message(chat_id: message.from.id, text: "3.Навчіться довіряти вашій інтуїції.")
                        	bot.api.send_message(chat_id: message.from.id, text: "4.Навчіться сприймати себе об’єктивно.")

                        	kb = [
                        		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Зберегти дані та завершити', callback_data: 'kdata'),
	                		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Завершити! Без збереження даних тесту', callback_data: 'kstop'),
	            		]
	            		markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
	            		bot.api.send_message(chat_id: message.from.id, text: 'Що обираєте?', reply_markup: markup)
                        end

                        if message.data == 'kadvice_l'
                        	bot.api.send_message(chat_id: message.from.id, text: "__________Наші поради__________")
                        	bot.api.send_message(chat_id: message.from.id, text: "1.Спостерігайте за реакціями людей з високим емоційним інтелектом на негативні ситуації та намагайтеся імплементувати їхній досвід у ваше життя.")
                        	bot.api.send_message(chat_id: message.from.id, text: "2.Ведіть активне соціальне життя оффлайн.")
                        	bot.api.send_message(chat_id: message.from.id, text: "3.Не бійтеся відкриватися та відкривати себе.")
                        	bot.api.send_message(chat_id: message.from.id, text: "4.Розвивайте емпатію.")

                        	kb = [
                        		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Зберегти дані та завершити', callback_data: 'kdata'),
	                		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Завершити! Без збереження даних тесту', callback_data: 'kstop'),
	            		]
	            		markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
	            		bot.api.send_message(chat_id: message.from.id, text: 'Що обираєте?', reply_markup: markup)
                        end

                        if message.data == 'khigh'
                        	bot.api.send_message(chat_id: message.from.id, text: "__________Це означає, що у вас__________")
                        	bot.api.send_message(chat_id: message.from.id, text: "1.Високий рівень психологічного благополуччя.")
                        	bot.api.send_message(chat_id: message.from.id, text: "2.Здатність розуміти свої позитивні і негативні сторони і можливості.")
                        	bot.api.send_message(chat_id: message.from.id, text: "3.Ухвалення інших людей такими, якими вони є.")
                        	bot.api.send_message(chat_id: message.from.id, text: "4.Прагнення максимально розвивати свої здібності і таланти.")

                        	kb = [
                        		TTelegram::Bot::Types::InlineKeyboardButton.new(text: 'Зберегти дані та завершити', callback_data: 'kdata'),
	                		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Завершити! Без збереження даних тесту', callback_data: 'kstop'),
	            		]
	            		markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
	            		bot.api.send_message(chat_id: message.from.id, text: 'Що обираєте?', reply_markup: markup)
                        end

                        if message.data == 'kmedium'
                        	bot.api.send_message(chat_id: message.from.id, text: "__________Це означає, що у вас__________")
                        	bot.api.send_message(chat_id: message.from.id, text: "1.Високий рівень самоконтролю.")
                        	bot.api.send_message(chat_id: message.from.id, text: "2.Відчуття психологічного благополуччя, позитивного ставлення до себе.")
                        	bot.api.send_message(chat_id: message.from.id, text: "3.Висока самооцінка.")
                        	bot.api.send_message(chat_id: message.from.id, text: "4.Довільний здійснення діяльності та спілкування на базі певних вольових зусиль.")

                        	kb = [
                        		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Зберегти дані та завершити', callback_data: 'kdata'),
	                		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Завершити! Без збереження даних тесту', callback_data: 'kstop'),
	            		]
	            		markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
	            		bot.api.send_message(chat_id: message.from.id, text: 'Що обираєте?', reply_markup: markup)
                        end

                        if message.data == 'klow'
                        	bot.api.send_message(chat_id: message.from.id, text: "__________Це означає, що у вас__________")
                        	bot.api.send_message(chat_id: message.from.id, text: "1.Низька самооцінка.")
                        	bot.api.send_message(chat_id: message.from.id, text: "2.Пригніченість своїми емоціями.")
                        	bot.api.send_message(chat_id: message.from.id, text: "3.Низький рівень усвідомленості своїх емоцій.")
                        	bot.api.send_message(chat_id: message.from.id, text: "4.Низька здатність відчувати, розуміти і приймати до уваги почуття і думки інших людей.")

                        	kb = [
                        		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Зберегти дані та завершити', callback_data: 'kdata'),
	                		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Завершити! Без збереження даних тесту', callback_data: 'kstop'),
	            		]
	            		markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
	            		bot.api.send_message(chat_id: message.from.id, text: 'Що обираєте?', reply_markup: markup)
                        end


        	when Telegram::Bot::Types::Message

		    	if message.text == '/start'
		    		bot.api.send_message(chat_id: message.from.id, text: "Добрий день! #{message.from.first_name}!")
		    		
		    		#ВИВЕСТИ ІНФУ ПРО ТЕСТ 
		    		bot.api.send_message(chat_id: message.from.id, text: "У загальному розумінні емоційний інтелект розглядається як здатність працювати з емоціями і проявляти емпатію. Це певна людська здатність до дуже точного відчуття ситуації, розуміння бажань оточуючих, стійкості до стресу і впливу негативних емоцій.")
		    		bot.api.send_message(chat_id: message.from.id, text: "Пройдіть тест та дізнайтесь більше про себе.")
		    		
		    		kb = [
					Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Почати тест', callback_data: 'kstart'),
	                		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Дізнатись більше про тест', callback_data: 'kinfo'),
	                		#ВИВЕСТИ МЕТОДИКУ ОЦІНЮВАННЯ

	                		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Корисні поради', callback_data: 'kadvice'),
	                		#ВИВЕСТИ КІЛЬКА ЗАГАЛЬНИХ ПОРАД
	            		]
	            		markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
	            		bot.api.send_message(chat_id: message.chat.id, text: 'Що обираєте?', reply_markup: markup)
			end

			if message.text == '_Повністю НЕ згоден🌑'
				points = points - 3
				tmp = true
			end

			if message.text == '_В основному НЕ згоден🌒'
				points = points - 2
				tmp = true
			end

			if message.text == '_Частково НЕ згоден🌓'
				points = points - 1
				tmp = true
			end

			if message.text == '_Частково згоден🌖'
				points = points + 1
				tmp = true
			end

			if message.text == '_В основному згоден🌕'
				points = points + 2
				tmp = true
			end

			if message.text == '_Повністю згоден☀️'
				points = points + 3
				tmp = true
			end


		    	if message.text == '/help'
		    		kb = [
					Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Призупинити тест⏸', callback_data: 'kpause'),
					#ЗАБРАТИ ВАРІАНТИ ВИБОРУ, ЗАПАМ'ЯТАТИ ФЛЕГ - 1 

					Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Продовжити тест▶️', callback_data: 'kcontin'),
					#ПРОДОВЖИТИ 

	                		Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Завершити! Без збереження даних тесту', callback_data: 'kstop'),
	            		]
	            		markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
	            		bot.api.send_message(chat_id: message.chat.id, text: 'Що обираєте?', reply_markup: markup)
			end
					  
	        	if message.text =~ /^\/stop/
	        		poits = 0
	        		flag = 0
				skale1 = 0
				skale2 = 0
				skale3 = 0
				skale4 = 0
				skale5 = 0
				kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
			    	bot.api.send_message(chat_id: message.chat.id,text: "Завершити!", reply_markup: kb)
			end

			if message.text =~ /^_/ && flag < 15
				bot.api.send_message(chat_id: message.from.id, text: " #{Skale[flag]}")

				if flag == 3
					skale1 = points	
				end
				if flag == 6
					skale2 = points	- skale1
				end
				if flag == 9
					skale3 = points	- (skale1 + skale2)
				end
				if flag == 12
					skale4 = points	- (skale1 + skale2 + skale3)
				end

				flag = flag + 1
				tmp = false
			end

			if flag == 15 && tmp == true
				if flag == 15
					skale5 = points	- (skale1 + skale2 + skale3 + skale4)
				end
				kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
				bot.api.send_message(chat_id: message.chat.id,text: "Ви пройшли тест!", reply_markup: kb)
				#bot.api.send_message(chat_id: message.from.id, text: " #{points}")
				#ВИВЕСТИ РЕЗУЛЬТАТИ ЗАЛЕЖНО ВІД БАЛІВ
				#ВИВЕСТИ ПОРАДИ ВІДПОВІДНО РЕЗУЛЬТАТІВ	
				if points >= 30
					bot.api.send_message(chat_id: message.from.id, text: "Вітаю! У вас високий рівень емоційного інтелекту.")
					kb = [
						Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Що це означає?', callback_data: 'khigh'),
						#ОЗНАКИ ВИСОКОГО РІВНЯ ЕІ

						Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Поради', callback_data: 'kadvice_h'),
						#ПОРАДИ
						Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Детальніше🔎', callback_data: 'skale_detail'),
						#ПОДИВИТИСЬ ДЕДАЛЬНІШУ ІНФОРМАЦІЮ 

						Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Корисні посилання', url: 'https://blog.agrokebety.com/shcho-take-emotsiynyy-intelekt'),

						Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Зберегти дані та завершити', callback_data: 'kdata'),
	                		
	                			Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Завершити! Без збереження даних тесту', callback_data: 'kstop'),
	            			]
	            			markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
	            			bot.api.send_message(chat_id: message.chat.id, text: 'Що обираєте?', reply_markup: markup)
				end

				#ВИВЕСТИ РЕЗУЛЬТАТИ ЗАЛЕЖНО ВІД БАЛІВ
				#ВИВЕСТИ ПОРАДИ ВІДПОВІДНО РЕЗУЛЬТАТІВ	
				if points >= 16 && points <= 29
					bot.api.send_message(chat_id: message.from.id, text: "У вас середній рівень емоційного інтелекту")
					kb = [
						Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Що це означає?', callback_data: 'kmedium'),
						#ОЗНАКИ ВИСОКОГО РІВНЯ ЕІ

						Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Поради', callback_data: 'kadvice_m'),
						#ПОРАДИ
						Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Детальніше🔎', callback_data: 'skale_detail'),
						#ПОДИВИТИСЬ ДЕДАЛЬНІШУ ІНФОРМАЦІЮ 

						Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Корисні посилання', url: 'https://blog.agrokebety.com/shcho-take-emotsiynyy-intelekt'),

						Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Зберегти дані та завершити', callback_data: 'kdata'),
	                		
	                			Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Завершити! Без збереження даних тесту', callback_data: 'kstop'),
	            			]
	            			markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
	            			bot.api.send_message(chat_id: message.chat.id, text: 'Що обираєте?', reply_markup: markup)
				end

				#ВИВЕСТИ РЕЗУЛЬТАТИ ЗАЛЕЖНО ВІД БАЛІВ
				#ВИВЕСТИ ПОРАДИ ВІДПОВІДНО РЕЗУЛЬТАТІВ
				if points <= 15
					bot.api.send_message(chat_id: message.from.id, text: "У вас низький рівень емоційного інтелекту")
					kb = [
						Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Що це означає?', callback_data: 'klow'),
						#ОЗНАКИ ВИСОКОГО РІВНЯ ЕІ

						Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Поради', callback_data: 'kadvice_l'),
						#ПОРАДИ
						Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Детальніше🔎', callback_data: 'skale_detail'),
						#ПОДИВИТИСЬ ДЕДАЛЬНІШУ ІНФОРМАЦІЮ 

						Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Корисні посилання', url: 'https://blog.agrokebety.com/shcho-take-emotsiynyy-intelekt'),

						Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Зберегти дані та завершити', callback_data: 'kdata'),
	                		
	                			Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Завершити! Без збереження даних тесту', callback_data: 'kstop'),
	            			]
	            			markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
	            			bot.api.send_message(chat_id: message.chat.id, text: 'Що обираєте?', reply_markup: markup)
				end
				
			end

		end
    		end
end