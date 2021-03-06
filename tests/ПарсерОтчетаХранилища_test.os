#использовать "../src/Классы/internal/ripper"
#Использовать asserts
#Использовать logos

Перем юТест;
Перем Лог;

Функция ПолучитьСписокТестов(Знач Тестирование) Экспорт

	юТест = Тестирование;
	
	ИменаТестов = Новый Массив;
	
	ИменаТестов.Добавить("ТестДолжен_ПроверитьЧтениеОтчетаХранилища");
	ИменаТестов.Добавить("ТестДолжен_ПроверитьЧтениеОтчетаХранилищаКавычкиВКомментарии");
	ИменаТестов.Добавить("ТестДолжен_ПроверитьЧтениеОтчетаХранилищаКомментарийПриМетке");
	
	Возврат ИменаТестов;

КонецФункции

Процедура ТестДолжен_ПроверитьЧтениеОтчетаХранилищаКомментарийПриМетке() Экспорт

	ПутьКФайлуОтчета = ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures", "report.mark.mxl.txt");
	ПарсерОтчетаХранилища = Новый ПарсерОтчетаХранилища;
	ТаблицаВерсийХранилища = ПарсерОтчетаХранилища.ПрочитатьФайлОтчетаХранилища(ПутьКФайлуОтчета);
	Ожидаем.Что(ТаблицаВерсийХранилища.Количество(), "Количество версий должно быть равны").Равно(3);
	Ожидаем.Что(ТаблицаВерсийХранилища[2].Комментарий).Равно(
		"Добавлен реквизит в справочник dneumoychev@PTSECURITY.RU, 2020-12-23 06:41:38"
	);
КонецПроцедуры 

Процедура ТестДолжен_ПроверитьЧтениеОтчетаХранилищаКавычкиВКомментарии() Экспорт
	ПутьКФайлуОтчета = ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures", "report.quoted.mxl.txt");
	ПарсерОтчетаХранилища = Новый ПарсерОтчетаХранилища;
	ТаблицаВерсийХранилища = ПарсерОтчетаХранилища.ПрочитатьФайлОтчетаХранилища(ПутьКФайлуОтчета);
	Ожидаем.Что(ТаблицаВерсийХранилища.Количество(), "Количество версий должно быть равны").Равно(2);
	Ожидаем.Что(ТаблицаВерсийХранилища[1].Комментарий).Равно(
		"Многострочный комментарий к версии хранилища, содержащий:
		|* ""двойные кавычки""
		|* 'одинарные кавычки'
		|* несколько кавычек подряд: """""" и '''");

КонецПроцедуры // ТестДолжен_ПроверитьЧтениеОтчетаХранилищаКавычкиВКомментарии()


Процедура ТестДолжен_ПроверитьЧтениеОтчетаХранилища() Экспорт
	
	ПутьКФайлуОтчета = ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures", "report.mxl.txt");
	// ПутьКФайлуОтчета = ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures", "1.mxl.txt");

	ПарсерОтчетаХранилища = Новый ПарсерОтчетаХранилища;
    ТаблицаВерсийХранилища = ПарсерОтчетаХранилища.ПрочитатьФайлОтчетаХранилища(ПутьКФайлуОтчета);

	Для каждого СтрокаВерсии Из ТаблицаВерсийХранилища Цикл
		
		СтрокаШаблонаЛога = "Добавили строку в таблицу версий:
		|Номер версии: %1
		|Автор:        %2
		|ГУИД_Автора:  %3
		|Дата:         %4
		|Комментарий:  %5
		|";
		Лог.Отладка(СтрокаШаблонаЛога, СтрокаВерсии.Номер,
									СтрокаВерсии.Автор,
									,
									СтрокаВерсии.Дата,
									СтрокаВерсии.Комментарий);

	КонецЦикла;


	Ожидаем.Что(ТаблицаВерсийХранилища.Количество(), "Количество версий должно быть равны").Равно(4);
	Ожидаем.Что(ТаблицаВерсийХранилища[0].Номер, "Номер версии должен быть равен").Равно(2);
	Ожидаем.Что(ТаблицаВерсийХранилища[0].Автор, "Автор версии должен быть равен").Равно("Администратор");
	Ожидаем.Что(ТаблицаВерсийХранилища[0].Комментарий, "Комментарий версии должен быть равен").Содержит("Изменения помещены
	|Еще строка
	|И еще строка
	|и Еще строка");
	Ожидаем.Что(ТаблицаВерсийХранилища[0].Дата, "Дата версии должен быть равен").Равно(Дата("20170526135608"));
	// Утверждения.ПроверитьРавенство(ТаблицаВерсийХранилища.Количество(),  4, "Количество версий должно быть 4");
	// Утверждения.ПроверитьИстину(СверитьМассивыТокенов(СпекМассив, КлючЗначение.Значение),"Токены не равны " + КлючЗначение.Ключ);


КонецПроцедуры

Лог = Логирование.ПолучитьЛог("oscript.lib.v8storage");
// Лог.УстановитьУровень(УровниЛога.Отладка);