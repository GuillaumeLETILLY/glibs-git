--@ SQL utilities for common database operations
--@ Create a new table if it doesn't exist
function gQueryCreateTable(tableName, columns)
	--@ Build column definitions
	local columnDefs = {}
	for name, dataType in pairs(columns) do
		table.insert(columnDefs, name .. " " .. dataType)
	end
	--@ Construct and execute query
	local query = string.format("CREATE TABLE IF NOT EXISTS %s (%s)", 
		tableName, 
		table.concat(columnDefs, ", ")
	)
	return sql.Query(query)
end

--@ Insert data into a table
function gQueryInsert(tableName, data)
	--@ Prepare columns and values
	local columns = table.GetKeys(data)
	local values = {}
	for _, col in ipairs(columns) do
		table.insert(values, sql.SQLStr(data[col]))
	end
	--@ Construct and execute query
	local query = string.format("INSERT INTO %s (%s) VALUES (%s)",
		tableName,
		table.concat(columns, ", "),
		table.concat(values, ", ")
	)
	return sql.Query(query)
end

--@ Enhanced select with multiple condition types
function gQuerySelect(tableName, columns, conditions)
	--@ Handle column selection
	local columnStr = "*"
	if columns then
		columnStr = table.concat(columns, ", ")
	end
	--@ Build base query
	local query = string.format("SELECT %s FROM %s", columnStr, tableName)
	--@ Add conditions if provided
	if conditions then
		local whereClause = {}
		for col, value in pairs(conditions) do
			if type(value) == "table" then
				--@ Handle special operators (>, <, >=, <=, LIKE, etc.)
				table.insert(whereClause, string.format("%s %s %s", 
					col, 
					value.operator or "=", 
					sql.SQLStr(value.value)
				))
			else
				table.insert(whereClause, string.format("%s = %s", col, sql.SQLStr(value)))
			end
		end
		query = query .. " WHERE " .. table.concat(whereClause, " AND ")
	end
	return sql.Query(query)
end

--@ Select by specific key (like steam_id)
function gQuerySelectByKey(tableName, keyName, keyValue, columns)
	--@ Handle column selection
	local columnStr = "*"
	if columns then
		columnStr = table.concat(columns, ", ")
	end
	--@ Build and execute query
	local query = string.format("SELECT %s FROM %s WHERE %s = %s",
		columnStr,
		tableName,
		keyName,
		sql.SQLStr(keyValue)
	)
	return sql.Query(query)
end

--@ Select with custom WHERE clause
function gQuerySelectCustom(tableName, columns, whereClause, orderBy, limit)
	--@ Handle column selection
	local columnStr = "*"
	if columns then
		columnStr = table.concat(columns, ", ")
	end
	--@ Build base query
	local query = string.format("SELECT %s FROM %s", columnStr, tableName)
	--@ Add WHERE clause if provided
	if whereClause then
		query = query .. " WHERE " .. whereClause
	end
	--@ Add ORDER BY if provided
	if orderBy then
		query = query .. " ORDER BY " .. orderBy
	end
	--@ Add LIMIT if provided
	if limit then
		query = query .. " LIMIT " .. limit
	end
	return sql.Query(query)
end

--@ Update table data with conditions
function gQueryUpdate(tableName, data, conditions)
	--@ Prepare SET clause
	local setPairs = {}
	for col, value in pairs(data) do
		table.insert(setPairs, string.format("%s = %s", col, sql.SQLStr(value)))
	end
	--@ Build base query
	local query = string.format("UPDATE %s SET %s", 
		tableName, 
		table.concat(setPairs, ", ")
	)
	--@ Add conditions if provided
	if conditions then
		local whereClause = {}
		for col, value in pairs(conditions) do
			if type(value) == "table" then
				table.insert(whereClause, string.format("%s %s %s", 
					col, 
					value.operator or "=", 
					sql.SQLStr(value.value)
				))
			else
				table.insert(whereClause, string.format("%s = %s", col, sql.SQLStr(value)))
			end
		end
		query = query .. " WHERE " .. table.concat(whereClause, " AND ")
	end
	return sql.Query(query)
end

--@ Delete data from table with conditions
function gQueryDelete(tableName, conditions)
	--@ Build base query
	local query = "DELETE FROM " .. tableName
	--@ Add conditions if provided
	if conditions then
		local whereClause = {}
		for col, value in pairs(conditions) do
			if type(value) == "table" then
				table.insert(whereClause, string.format("%s %s %s", 
					col, 
					value.operator or "=", 
					sql.SQLStr(value.value)
				))
			else
				table.insert(whereClause, string.format("%s = %s", col, sql.SQLStr(value)))
			end
		end
		query = query .. " WHERE " .. table.concat(whereClause, " AND ")
	end
	return sql.Query(query)
end

--@ Drop table if exists
function gQueryDropTable(tableName)
	local query = string.format("DROP TABLE IF EXISTS %s", tableName)
	return sql.Query(query)
end

--@ Check if table exists
function gQueryTableExists(tableName)
	return sql.TableExists(tableName)
end

--@ Get all tables
function gQueryGetTables()
	return sql.GetTables()
end