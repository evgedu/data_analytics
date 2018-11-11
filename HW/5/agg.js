/*
        Написать запрос, который выводит общее число тегов
*/
print("tags count: ", db.tags.find().count());
/*
        Добавляем фильтрацию: считаем только количество тегов woman
*/
print("only woman tags count: ", db.tags.find({"name": "woman"}).count());
print("with woman tags count: ", db.tags.find({"name": /woman/i}).count());
/*
        Очень сложный запрос: используем группировку данных посчитать количество вхождений для каждого тега
        и напечатать top-3 самых популярных
*/

printjson(
        db.tags.aggregate([
                {"$group": {
                                _id : "$name",
                                count : { $sum: 1 }
                           }
                },
                {$sort: { count : -1}},
                {$limit: 3}
        ])['_batch']
);
