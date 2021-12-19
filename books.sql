db.books.find().limit(1)

db.books.find({pageCount: {$lt: 500, $gte: 400}}, {
_id: 0,
title: 1,
pageCount: 1,
publishedDate: 1
}).sort({publishedDate: -1})

db.books.find({categories: "Python"}, {title: 1, categories: 1})

db.books.find({categories: ["Python"]}, {title: 1, categories: 1})

db.books.find({categories: {$in: ["Python", "PHP"]}}, {
title: 1,
categories: 1,
})

db.books.find({categories: "Python"}, {title: 1, categories: 1, pageCount: 1}).sort({pageCount: -1}).limit(5)

db.books.find({authors: {$in: ["Marc Harter", "Alex Holmes"]}}, {
title: 1,
categories: 1,
authors: 1
})

db.books.getIndexes()

db.books.find({categories: "Python"}).explain("executionStats")

db.books.createIndex({categories: 1})

db.books.aggregate( [
{
$group: {
_id: "$status",
avgPageCount: { $avg: "$pageCount" }
}
}
] )

db.books.aggregate( [
{
$group: {
_id: "$status",
avgPageCount: { $avg: "$pageCount" },
minPageCount: { $min: "$pageCount" },
maxPageCount: { $max: "$pageCount" }
}
}
] )

db.books.aggregate([
{$addFields: {year: {$year: "$publishedDate"}}},
{
$group: {
_id: "$year",
count: {$sum: 1}
}
},
{$sort: {count: -1}}
])

db.books.aggregate([
{$match: {publishedDate: {$ne: null}}},
{$addFields: {year: {$year: "$publishedDate"}}}, {
$group: {
_id: "$year",
count: {$sum: 1}
}
}, {$sort: {count: -1}}])

db.books.aggregate([
{$addFields: {year: {$year: "$publishedDate"}}},
{
$group: {
_id: {year: "$year", status: "$status"},
count: {$sum: 1}
}
}
])

db.books.aggregate([
{ $match : {status: "PUBLISH" } },
{ $unwind: "$categories" },
{ $group: { _id: "$categories", avgPageCount: { $avg: "$pageCount" } } },
{ $sort: {avgPageCount: -1} }
])

db.books.aggregate([
{$unwind: "$authors"},
{$match: {authors: {$ne: ""}}},
{$group: {_id: "$authors", count: {$sum: 1}, avgPageCount: {$avg: "$pageCount"}}},
{$sort: {count: -1}},
{$limit: 5}
])

db.books.aggregate([{$project: {authorsCount: {$size: '$authors'}}}, {
$group: {
_id: null,
avgAuthorsCount: {$avg: '$authorsCount'}
}
}])

db.books.aggregate([{$project: {categoriesCount: {$size: '$categories'}}}, {
$group: {
_id: null,
avgCategoriesCount: {$avg: '$categoriesCount'}
}
}])

db.books.aggregate([
{$addFields: {year: {$year: "$publishedDate"}}},
{ $unwind: "$authors" },
{ $group: { _id: "$authors", years: { $addToSet: "$year" } } }
])

db.books.aggregate([
{$addFields: {year: {$year: "$publishedDate"}}},
{ $unwind: "$categories" },
{ $group: { _id: "$categories", years: { $addToSet: "$year" } } }
])
