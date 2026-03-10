//
//  HealthMilestone.swift
//  smoking-lose
//
//  Created by Codex on 28.02.2026.
//

import Foundation

extension HealthMilestone {
    var title: String { L10n.text(titleRU, titleEN) }
    var description: String { L10n.text(descriptionRU, descriptionEN) }
    var timelineLabel: String { L10n.text(labelRU, labelEN) }

    var articleSummary: String {
        switch key {
        case "heart-rate-drop":
            return L10n.text(
                "После отказа от курения сердце довольно быстро перестает работать в режиме постоянной никотиновой стимуляции. Это один из самых ранних объективных признаков, что восстановление уже запущено.",
                "After quitting, the heart quickly stops working under constant nicotine stimulation. This is one of the earliest objective signs that recovery is already underway."
            )
        case "toxins-clearing":
            return L10n.text(
                "В первый час организм уже начинает избавляться от части продуктов табачного дыма. Это не ощущается как резкий поворот самочувствия, но физиологический процесс очистки уже стартует.",
                "Within the first hour, the body already starts clearing part of the toxic burden from tobacco smoke. You may not feel it dramatically yet, but the cleanup process has begun."
            )
        case "oxygen-recovery":
            return L10n.text(
                "Даже в первые часы кровь начинает лучше переносить кислород. Это не означает мгновенного комфорта, но база для дальнейшего восстановления уже улучшается.",
                "Within the first hours, blood begins carrying oxygen better. That does not mean instant comfort, but the groundwork for further recovery is already improving."
            )
        case "carbon-monoxide-normal":
            return L10n.text(
                "Нормализация угарного газа особенно важна для сердца, сосудов и тканей, которым постоянно нужен кислород. Это один из ключевых ранних рубежей в официальных медицинских таймлайнах.",
                "Normalizing carbon monoxide is especially important for the heart, blood vessels, and oxygen-hungry tissues. It is one of the key early milestones in official medical timelines."
            )
        case "nicotine-clears":
            return L10n.text(
                "Через сутки организм уже живет без новой дозы никотина. Именно поэтому этот период может быть психологически непростым, но физиологически он очень важен.",
                "After a full day, the body is already going without a new dose of nicotine. That is why the period can feel psychologically difficult, yet it is physiologically important."
            )
        case "heart-attack-risk-begins-to-drop":
            return L10n.text(
                "После первых суток без сигарет сердечно-сосудистая система уже получает передышку. Это не мгновенная гарантия, а ранний сдвиг риска в более безопасную сторону.",
                "After the first smoke-free day, the cardiovascular system is already getting some relief. This is not an instant guarantee, but an early risk shift in a better direction."
            )
        case "taste-smell-return":
            return L10n.text(
                "Возврат вкуса и запаха часто заметен пользователю напрямую. Это один из самых мотивирующих этапов, потому что изменения ощущаются не только в цифрах, но и в повседневной жизни.",
                "The return of taste and smell is often directly noticeable. It is one of the most motivating stages because changes are felt not only in numbers, but also in daily life."
            )
        case "breathing-eases":
            return L10n.text(
                "Когда дыхание становится чуть свободнее, многие впервые чувствуют, что отказ реально работает. В это время особенно полезно поддерживать себя прогулками и ровным режимом сна.",
                "When breathing starts feeling a little easier, many people first feel that quitting is actually working. This is a good time to support yourself with walks and steady sleep."
            )
        case "circulation-improves":
            return L10n.text(
                "Через пару недель улучшается переносимость нагрузки и повседневных дел. Это хороший момент замечать практические бонусы: ходить быстрее, меньше уставать, легче подниматься по лестнице.",
                "After a couple of weeks, tolerance to activity and daily tasks improves. This is a good time to notice practical gains: walking faster, tiring less, and handling stairs more easily."
            )
        case "nicotine-receptors-normalize":
            return L10n.text(
                "Примерно к концу первого месяца мозг уже меньше живет в режиме постоянной никотиновой стимуляции. Это не отменяет тягу полностью, но помогает ей терять остроту.",
                "By about the end of the first month, the brain is less locked into constant nicotine stimulation. That does not erase cravings entirely, but it helps them lose intensity."
            )
        case "cough-begins-to-ease":
            return L10n.text(
                "Первый месяц без курения часто меняет ощущение контроля над собой. Организм продолжает очищаться, а кашель и одышка у части людей уже начинают уменьшаться.",
                "The first smoke-free month often changes how much control you feel you have. The body keeps clearing, and for some people cough and shortness of breath already begin to ease."
            )
        case "circulation-window-upper-bound":
            return L10n.text(
                "Эта точка отмечает верхнюю границу официального окна 2-12 недель, в котором WHO и NHS описывают улучшение кровообращения и работы легких. У одних изменения заметны раньше, у других ближе к концу этого периода.",
                "This marks the upper bound of the official 2 to 12 week window in which WHO and the NHS describe improvements in circulation and lung function. Some people notice changes earlier, others closer to the end of that period."
            )
        case "lung-function-improving":
            return L10n.text(
                "На этой дистанции восстановление уже больше похоже не на вспышку мотивации, а на реальную перестройку. Улучшения дыхания и выносливости становятся заметнее в обычной жизни.",
                "At this distance, recovery feels less like a burst of motivation and more like a real reset. Improvements in breathing and stamina become more visible in daily life."
            )
        case "lungs-clear-better":
            return L10n.text(
                "Полгода без курения часто дают ощущение более стабильного дыхания и меньшей зависимости от старых триггеров. Это сильная среднесрочная точка опоры.",
                "Six months without smoking often brings more stable breathing and less dependence on old triggers. It is a strong mid-term anchor point."
            )
        case "cough-sob-window-upper-bound":
            return L10n.text(
                "Это верхняя граница официального окна 3-9 месяцев, в котором кашель, свистящее дыхание и одышка у многих становятся слабее. В британских материалах также упоминается возможный прирост функции легких до 10%.",
                "This is the upper bound of the official 3 to 9 month window in which cough, wheeze, and shortness of breath often improve. UK guidance also mentions lung function gains of up to 10%."
            )
        case "chd-risk-half":
            return L10n.text(
                "Год без курения уже влияет не только на самочувствие, но и на долгосрочный сердечно-сосудистый риск. Это важный медицинский и психологический рубеж.",
                "A full year without smoking affects not only how you feel, but also long-term cardiovascular risk. It is an important medical and psychological milestone."
            )
        case "heart-attack-risk-drops-sharply":
            return L10n.text(
                "Через 1-2 года преимущества для сердца становятся более выраженными. Это хороший момент смотреть на отказ как на долгую инвестицию в здоровье, а не только как на борьбу с привычкой.",
                "After one to two years, the benefits for the heart become more pronounced. This is a good time to see quitting as a long-term health investment, not only a fight with a habit."
            )
        case "stroke-risk-declines":
            return L10n.text(
                "Пятилетний рубеж показывает, что отказ меняет уже крупные сосудистые риски. Это одна из причин, почему стабильность на длинной дистанции действительно окупается.",
                "The five-year milestone shows that quitting changes major vascular risks. It is one of the reasons consistency over the long run truly pays off."
            )
        case "coronary-risk-half-window":
            return L10n.text(
                "CDC описывает окно 3-6 лет, в котором добавочный риск ишемической болезни сердца снижается примерно вдвое. Здесь показана его верхняя граница, чтобы отметить завершение этого крупного диапазона.",
                "The CDC describes a 3 to 6 year window in which added coronary heart disease risk drops by about half. This app marks the upper bound of that window to show the end of the range."
            )
        case "lung-cancer-risk-half":
            return L10n.text(
                "Десятилетний рубеж важен тем, что он связан уже с крупными долгосрочными онкологическими рисками. Это не гарантия, а заметное снижение вероятности по сравнению с продолжением курения.",
                "The ten-year milestone matters because it is tied to major long-term cancer risks. It is not a guarantee, but a meaningful reduction compared with continuing to smoke."
            )
        case "other-cancer-risks-drop":
            return L10n.text(
                "К этому сроку официальные источники отмечают не только пользу для риска рака легких, но и дальнейшее снижение риска ряда других опухолей, связанных с табаком.",
                "By this point, official sources note benefits not only for lung cancer risk, but also continued declines in several other tobacco-related cancers."
            )
        case "chd-near-nonsmoker":
            return L10n.text(
                "Через 15 лет отказ от курения меняет сердечно-сосудистый прогноз очень заметно. Это результат накопленного эффекта, который работает годами.",
                "After 15 years, quitting changes cardiovascular outlook in a major way. It is the result of a cumulative effect that keeps working for years."
            )
        default:
            return L10n.text(
                "На длинной дистанции польза отказа от курения продолжает накапливаться. Даже спустя годы организм выигрывает по сравнению с продолжением курения.",
                "Over the long run, the benefits of quitting keep accumulating. Even years later, the body still benefits compared with continued smoking."
            )
        }
    }

    var articlePoints: [String] {
        switch key {
        case "heart-rate-drop":
            return [
                L10n.text("Никотин перестает резко подталкивать сердечный ритм вверх.", "Nicotine stops sharply pushing heart rate upward."),
                L10n.text("Артериальное давление начинает отходить от табачной стимуляции.", "Blood pressure starts moving away from tobacco-driven stimulation."),
                L10n.text("Это ранний, но реальный физиологический сдвиг в сторону восстановления.", "This is an early but real physiological shift toward recovery.")
            ]
        case "toxins-clearing":
            return [
                L10n.text("В организме уже стартуют процессы выведения части табачных токсинов.", "The body has already started clearing part of the toxic tobacco burden."),
                L10n.text("Это ранний рубеж, который официальные материалы ставят уже в первый час.", "This is an early milestone that official guidance places within the first hour."),
                L10n.text("Даже очень короткая дистанция без курения уже имеет физиологический смысл.", "Even a very short smoke-free stretch already matters physiologically.")
            ]
        case "oxygen-recovery":
            return [
                L10n.text("Уровень угарного газа в крови уже заметно снижается.", "Carbon monoxide in the blood has already dropped noticeably."),
                L10n.text("Кислороду легче доходить до органов и мышц.", "Oxygen can reach organs and muscles more easily."),
                L10n.text("Даже небольшая пауза без курения уже полезна для тела.", "Even a short smoke-free pause already benefits the body.")
            ]
        case "carbon-monoxide-normal":
            return [
                L10n.text("Кровь переносит кислород эффективнее, чем во время активного курения.", "Blood carries oxygen more efficiently than during active smoking."),
                L10n.text("Нагрузка на сердце и сосуды уменьшается.", "The load on the heart and vessels decreases."),
                L10n.text("Это один из самых часто цитируемых ранних медицинских этапов.", "This is one of the most frequently cited early medical milestones.")
            ]
        case "nicotine-clears":
            return [
                L10n.text("Никотин в крови падает до нуля.", "Nicotine in the bloodstream drops to zero."),
                L10n.text("Организм перестраивается на жизнь без новой табачной подпитки.", "The body shifts toward functioning without new tobacco input."),
                L10n.text("Психологически этот этап может быть сложным, но он важен для устойчивого отказа.", "Psychologically, this stage can be difficult, but it matters for a stable quit attempt.")
            ]
        case "heart-attack-risk-begins-to-drop":
            return [
                L10n.text("После первых суток сердечно-сосудистая нагрузка уже уменьшается.", "After the first day, cardiovascular strain is already decreasing."),
                L10n.text("Официальные источники связывают этот срок с ранним снижением риска сердечного приступа.", "Official sources tie this timeframe to an early drop in heart attack risk."),
                L10n.text("Это не гарантия, а ранний статистический сдвиг в лучшую сторону.", "This is not a guarantee, but an early statistical shift in a better direction.")
            ]
        case "taste-smell-return":
            return [
                L10n.text("Легкие начинают выводить слизь и остатки дыма.", "The lungs start clearing mucus and smoke residue."),
                L10n.text("Запахи и вкус нередко ощущаются ярче.", "Smells and taste often feel stronger."),
                L10n.text("Изменения становятся заметны не только в анализах, но и в быту.", "Changes become noticeable not only in metrics, but also in daily life.")
            ]
        case "breathing-eases":
            return [
                L10n.text("Бронхи начинают расслабляться, дыхание может стать свободнее.", "The bronchial tubes begin to relax, and breathing may feel easier."),
                L10n.text("Энергии часто становится чуть больше.", "Energy often begins to rise."),
                L10n.text("Это хороший момент поддержать себя прогулками и водой.", "This is a good time to support yourself with walks and hydration.")
            ]
        case "circulation-improves":
            return [
                L10n.text("Кровообращение улучшается, а мышцам легче получать кислород.", "Circulation improves and muscles get oxygen more easily."),
                L10n.text("Повседневная нагрузка переносится проще.", "Everyday activity feels easier."),
                L10n.text("Этот этап часто хорошо ощущается на прогулках и лестницах.", "This stage is often noticeable during walking and stairs.")
            ]
        case "nicotine-receptors-normalize":
            return [
                L10n.text("Никотиновые рецепторы мозга постепенно возвращаются ближе к норме.", "Nicotine receptors in the brain gradually move closer to normal."),
                L10n.text("Тяга может еще возникать, но мозг уже не так жестко требует никотиновую стимуляцию.", "Cravings may still happen, but the brain is less rigidly locked into nicotine stimulation."),
                L10n.text("Это объясняет, почему к концу месяца у части людей становится легче держать дистанцию.", "This helps explain why, by the end of the month, some people find it easier to keep going.")
            ]
        case "cough-begins-to-ease":
            return [
                L10n.text("Кашель и одышка могут начать уменьшаться.", "Cough and shortness of breath can begin to ease."),
                L10n.text("Легкие продолжают восстанавливать нормальную очистку.", "The lungs continue restoring normal clearing function."),
                L10n.text("Первый месяц часто психологически укрепляет уверенность.", "The first month often strengthens confidence psychologically.")
            ]
        case "circulation-window-upper-bound":
            return [
                L10n.text("WHO и NHS описывают улучшение кровообращения и функции легких в диапазоне от 2 до 12 недель.", "WHO and the NHS describe improvements in circulation and lung function across a 2 to 12 week range."),
                L10n.text("Это не один день резкой перемены, а окно постепенного восстановления.", "This is not a single day of sudden change, but a window of gradual recovery."),
                L10n.text("У части людей практические бонусы заметны раньше, у части ближе к этой границе.", "Some people notice practical gains earlier, while others notice them closer to this boundary.")
            ]
        case "lung-function-improving":
            return [
                L10n.text("Функция легких продолжает расти.", "Lung function keeps improving."),
                L10n.text("Обычная активность дается легче, чем в первые недели.", "Ordinary activity feels easier than in the first weeks."),
                L10n.text("Это уже стадия устойчивого, а не только стартового восстановления.", "This is already a stage of sustained, not merely initial, recovery.")
            ]
        case "lungs-clear-better":
            return [
                L10n.text("Легкие лучше справляются с очисткой слизи.", "The lungs do a better job clearing mucus."),
                L10n.text("Кашель и ощущение нехватки воздуха часто уменьшаются.", "Cough and the feeling of breathlessness often decrease."),
                L10n.text("Триггеры привычки тоже нередко теряют силу.", "Habit triggers also often lose some of their strength.")
            ]
        case "cough-sob-window-upper-bound":
            return [
                L10n.text("Официальные материалы NHS описывают окно 3-9 месяцев для снижения кашля, свиста и одышки.", "Official NHS guidance describes a 3 to 9 month window for reductions in cough, wheeze, and shortness of breath."),
                L10n.text("Легочная функция за это время может вырасти примерно до 10%.", "Lung function can improve by up to about 10% during this period."),
                L10n.text("Это еще один пример того, что восстановление идет диапазонами, а не по одному дню.", "This is another example of recovery happening over ranges, not on a single exact day.")
            ]
        case "chd-risk-half":
            return [
                L10n.text("Риск ишемической болезни сердца примерно вдвое ниже, чем при продолжении курения.", "Coronary heart disease risk is about half of what it would be with continued smoking."),
                L10n.text("Это один из самых сильных рубежей первого года.", "This is one of the strongest milestones of the first year."),
                L10n.text("Польза затрагивает не только симптомы, но и долгосрочный прогноз.", "The benefit affects not just symptoms, but also long-term outlook.")
            ]
        case "heart-attack-risk-drops-sharply":
            return [
                L10n.text("Риск инфаркта начинает снижаться особенно заметно.", "Heart attack risk starts dropping more sharply."),
                L10n.text("Эффект отказа для сердца накапливается из года в год.", "The effect of quitting for the heart accumulates year by year."),
                L10n.text("Это хороший ориентир для долгосрочной мотивации.", "This is a good anchor for long-term motivation.")
            ]
        case "stroke-risk-declines":
            return [
                L10n.text("Риск инсульта снижается по сравнению с продолжением курения.", "Stroke risk decreases compared with continued smoking."),
                L10n.text("Лишний коронарный риск тоже становится значительно меньше.", "Added coronary risk also becomes much lower."),
                L10n.text("На этой дистанции особенно заметен эффект стабильности.", "At this distance, the effect of consistency is especially visible.")
            ]
        case "coronary-risk-half-window":
            return [
                L10n.text("CDC описывает официальный диапазон 3-6 лет для снижения добавочного риска ИБС примерно наполовину.", "The CDC describes an official 3 to 6 year range for cutting added coronary heart disease risk by about half."),
                L10n.text("Приложение фиксирует верхнюю границу этого окна как отдельный рубеж.", "The app marks the upper bound of that window as a distinct milestone."),
                L10n.text("Это помогает показать, что долгосрочная польза продолжает накапливаться и после первых лет.", "This helps show that long-term benefit keeps accumulating well beyond the first years.")
            ]
        case "lung-cancer-risk-half":
            return [
                L10n.text("Риск рака легких падает примерно вдвое по сравнению с продолжением курения.", "Lung cancer risk drops by about half compared with continued smoking."),
                L10n.text("Это не медицинская гарантия, а статистическое снижение риска.", "This is not a medical guarantee, but a statistical reduction in risk."),
                L10n.text("Длинная дистанция особенно важна для онкологических рисков.", "Long-term consistency matters especially for cancer risk.")
            ]
        case "other-cancer-risks-drop":
            return [
                L10n.text("К этому сроку снижаются риски ряда других видов рака, связанных с табаком.", "By this point, risks for several other tobacco-related cancers also decline."),
                L10n.text("CDC отдельно упоминает гортань, пищевод, мочевой пузырь, почку и поджелудочную железу.", "The CDC specifically mentions the larynx, esophagus, bladder, kidney, and pancreas."),
                L10n.text("Это показывает, что польза отказа не ограничивается только легкими.", "This shows that the benefit of quitting is not limited to the lungs.")
            ]
        case "chd-near-nonsmoker":
            return [
                L10n.text("Риск ИБС приближается к уровню человека, который не курит.", "Coronary heart disease risk approaches that of a non-smoker."),
                L10n.text("Сердце и сосуды выигрывают от долгой дистанции без табака.", "The heart and blood vessels benefit from a long tobacco-free stretch."),
                L10n.text("Это один из ключевых долгосрочных медицинских ориентиров.", "This is one of the key long-term medical milestones.")
            ]
        default:
            return [
                L10n.text("Для ряда опухолей риск становится близок к риску некурящих.", "For some cancers, risk becomes close to that of non-smokers."),
                L10n.text("Долгий отказ продолжает работать даже через много лет.", "Long-term cessation keeps paying off even many years later."),
                L10n.text("Это подтверждает ценность устойчивости на длинной дистанции.", "This reinforces the value of long-run consistency.")
            ]
        }
    }

    var sourceCaption: String {
        L10n.text(
            "Основано на обобщенных данных WHO, CDC, NHS, NHS 111 Wales и Smokefree.gov. Носит информационный характер и не заменяет консультацию врача.",
            "Based on summarized WHO, CDC, NHS, NHS 111 Wales, and Smokefree.gov data. Informational only and not a substitute for medical advice."
        )
    }
}
