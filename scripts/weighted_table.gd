class_name WeightedTable
#使用weighted table来控制敌人生成

var items : Array[Dictionary] = []
var weight_sum = 0

#增加或减少，都要重新计算权重
func add_item(item, weight : int):
	items.append({"items" : item, "weight" : weight})
	weight_sum += weight


func remove_item(item_to_remove):
	items = items.filter(func (item): return item["items"] != item_to_remove)
	weight_sum = 0
	for item in items:
		weight_sum += item["weight"]


func pick_item(exclude : Array = []):
	var adjusted_items : Array[Dictionary] = items
	var adjusted_weight_sum = weight_sum
	if exclude.size() > 0:
		adjusted_items = []
		adjusted_weight_sum = 0
		for item in items:
			if item['items'] in exclude:
				continue
				#continue means stop and go to the next loop
			adjusted_items.append(item)
			adjusted_weight_sum += item['weight']
			
	var chosen_weight = randi_range(1, adjusted_weight_sum)
	var iteration_sum = 0
	for item in adjusted_items:
		iteration_sum += item["weight"]
		if chosen_weight <= iteration_sum:
			return item["items"]
