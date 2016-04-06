class ObjectivePlox
  prechigh
    right POINT
    nonassoc NOT
    left MOD
    left MULT DIV
    left PLUS MINUS
    left MTHAN MEQUAL LTHAN LEQUAL EQUALITY DIFFERENT
    left AND OR
    right EQUAL PLUSASSIGN MINUSASSIGN MULTASSIGN DIVASSIGN ORASSIGN ANDASSIGN MODASSIGN
    nonassoc SEMIC
  preclow
rule
  supreme_plox:
    plox_generation                                   { puts "OP! Programa compilado exitosamente."; ap $speciesBook; ap $constantBook}

  plox_generation:
    /* empty */                                       {}
    | type_declaration plox_generation                {}

  type_declaration:
    HABEMVS class_declaration SEMIC                   {}

  class_declaration:
    SPECIES code_new_class code_heirof BLEFT class_body BRIGHT      {}

  code_new_class:
    ID { newSpecies(val[0][0]) }

  code_heirof:
    /* empty */                                       {}
    | HEIROF ID                                       { heirSpecies(val[1][0]) }

  class_body:
    class_variable_block class_function_block         {}

  class_variable_block:
    /* empty */                                       {}
    | variable_declaration class_variable_block       {}

  class_function_block:
    /* empty */                                       {}
    | method_declaration class_function_block         {}

  modifier:
    OPEN                                              { $actualModifier = true }
    | HIDDEN                                          { $actualModifier = false }

  variable_declaration:
    variable_is_modifiable variable_scope type some_variables SEMIC            {}

  variable_scope:
    /* empty */                                       {}
    | modifier                                        {}

  variable_is_modifiable:
    VAR                                               { $actualModifier = false; $isVariable = true }
    | ETERNAL                                         { $actualModifier = false; $isVariable = false }

  some_variables:
    code_new_variable next_variable                   {}

  code_new_variable:
    ID  { newVariable(val[0][0]) }

  next_variable:
    /* empty */                                       {}
    | COMA some_variables                      {}

  type:
    type_specifier type1                              {}

  type1:
    /* empty */                                       {}
    | type2                                           {}

  type2:
    SBLEFT expression SBRIGHT type1           {}

  variable_assignment:
    ID variable_assignment1 assign_operator variable_value      {}

  variable_assignment1:
    /* empty */                                       {}
    | variable_assignment4 variable_assignment5       {}

  assign_operator:
    EQUAL                                             {}
    | PLUSASSIGN
    | MINUSASSIGN
    | MULTASSIGN
    | DIVASSIGN
    | ORASSIGN
    | ANDASSIGN
    | MODASSIGN

  variable_assignment4:
    SBLEFT expression SBRIGHT variable_assignment5      {}

  variable_assignment5:
    /* empty */                                       {}
    | variable_assignment4                            {}

  method_declaration:
    new_function_code method_declaration1 type method_declaration2 PLEFT method_declaration3 PRIGHT method_declaration4          {}

  new_function_code:
    FUNK { $actualModifier = true }

  method_declaration1:
    /* empty */                                       {}
    | modifier                                        {}

  method_declaration2:
    ID                                                { newMethod(val[0][0]) }
    | CHIEF                                           { newMethod("chief")}

  method_declaration3:
    /* empty */                                       {}
    | parameter_list method_declaration3              {}

  method_declaration4:
    statement_block                                   {}
    | SEMIC                                           {}


  type_specifier:
    LOGIC                                             { $actualType = "logic" }
    | CHAR                                            { $actualType = "char" }
    | NUMBER                                          { $actualType = "number" }
    | DECIMAL                                         { $actualType = "decimal" }
    | ID                                              { $actualType = val[0][0] }
    | OBLIVION                                        { $actualType = "oblivion" }
    | STRING                                          { $actualType = "string" }

  num_operator:
    MULT                                              { $operatorStack.push(val[0][0]) }
    | DIV                                             { $operatorStack.push(val[0][0]) }
    | MOD                                             { $operatorStack.push(val[0][0]) }
    | PLUS                                            { $operatorStack.push(val[0][0]) }
    | MINUS                                           { $operatorStack.push(val[0][0]) }

  variable_value:
    expression                                        {}
    | HEAR PLEFT PRIGHT                               {}

  parameter_list:
    parameter parameter_list1                         {}

  parameter_list1:
    /* empty */                                       {}
    | COMA parameter_list                             {}

  statement_block:
    BLEFT statement_block1 statement_block2 BRIGHT    {}

  statement_block1:
    /* empty */                                       {}
    | variable_declaration statement_block1           {}

  statement_block2:
    /* empty */                                       {}
    | statement statement_block2                      {}

  reference_expression:
    NULL                                              {}
    | ITSELF                                          {}
    | ID                                              {}
    | reference_expression2                           {}

  reference_expression2:
    reference_expression reference_expression5        {}

  reference_expression5:
    PLEFT reference_expression6 PRIGHT                {}
    | SBLEFT expression SBRIGHT                       {}
    | POINT reference_expression                      {}

  reference_expression6:
    /* empty */                                       {}
    | arglist                                         {}

  parameter:
    type ID parameter1                                { newArgument(val[0][0], val[1][0]) }

  parameter1:
    /* empty */                                       {}
    | parameter2                                      {}

  parameter2:
    SBLEFT expression SBRIGHT parameter3              {}

  parameter3:
    /* empty */                                       {}
    | parameter2                                      {}

  statement:
    variable_assignment SEMIC                         {}
    | SAY PLEFT expression PRIGHT SEMIC               {}
    | expression SEMIC                                {}
    | statement_block                                 {}
    | unless_statement                                {}
    | if_statement                                    {}
    | do_statement                                    {}
    | while_statement                                 {}
    | REPLY statement1 SEMIC                          {}
    | SEMIC                                           {}

  statement1:
    /* empty */                                       {}
    | expression

  expression:
    expression num_operator expression                { validateArithmeticExpression() }
    | expression testing_operator expression          {}
    | NOT expression                                  {}
    | expression boolean_operator expression          {}
    | TRUE                                            {}
    | FALSE                                           {}
    | PLEFT expression PRIGHT                         {}
    | literal_expression                              {}
    | reference_expression                            {}

  arglist:
    expression arglist1                               {}

  arglist1:
    /* empty */                                       {}
    | COMA arglist                                    {}

  unless_statement:
    UNLESS PLEFT expression PRIGHT statement unless_statement1    {}

  unless_statement1:
    /* empty */                                       {}
    | ELSE statement                                  {}

  if_statement:
    IF PLEFT expression PRIGHT statement if_statement1  {}

  if_statement1:
    /* empty */                                       {}
    | ELSE statement                                  {}

  do_statement:
    DO statement WHILE PLEFT expression PRIGHT SEMIC  {}

  while_statement:
    WHILE PLEFT expression PRIGHT statement           {}

  testing_operator:
    MTHAN                                             {}
    | LTHAN                                           {}
    | MEQUAL                                          {}
    | LEQUAL                                          {}
    | EQUALITY                                        {}
    | DIFFERENT                                       {}

  boolean_operator:
    AND                                               {}
    | OR                                              {}

  literal_expression:
    CTED                                              { newConstant(val[0][0], val[0][1]) }
    | CTEN                                            { newConstant(val[0][0], val[0][1]) }
    | CTESTRING                                       { newConstant(val[0][0], val[0][1]) }

end

---- header

  require_relative 'lexer'  # Se agrega el lexer al programa de racc.
  require "awesome_print"
  $line_number = 0          # Se inicializa la variable que guarda el numero de linea en la cual se encuentra el error.
  $speciesBook = Hash.new{}
  $actualSpecies
  $actualModifier
  $isVariable
  $actualType
  $actualMethod
  $actualScope
  $operatorStack = Array.new
  $operandStack = Array.new
  $vectorCuadruplo = Array.new
  $constantBook = Hash.new
  $theMagicNumber = 10000
  $magicReference = {
    "global" => {
      "number" => 0,
      "decimal" => 1,
      "string" => 2,
      "char" => 3,
      "logic" => 4
    },
    "local" => {
      "number" => 5,
      "decimal" => 6,
      "string" => 7,
      "char" => 8,
      "logic" => 9
    },
    "temporal" => {
      "number" => 10,
      "decimal" => 11,
      "string" => 12,
      "char" => 13,
      "logic" => 14
    },
    "constant" => {
      "number" => 15,
      "decimal" => 16,
      "string" => 17,
      "char" => 18,
      "logic" => 19
    }
  }
  $magicCounter = {
    "global" => {
      "number" => 0,
      "decimal" => 0,
      "string" => 0,
      "char" => 0,
      "logic" => 0
    },
    "local" => {
      "number" => 0,
      "decimal" => 0,
      "string" => 0,
      "char" => 0,
      "logic" => 0
    },
    "temporal" => {
      "number" => 0,
      "decimal" => 0,
      "string" => 0,
      "char" => 0,
      "logic" => 0
    },
    "constant" => {
      "number" => 0,
      "decimal" => 0,
      "string" => 0,
      "char" => 0,
      "logic" => 0
    }
  }
  $semanticCube = {
    "logic" => {
      "logic" => {
        "!=" => "logic",
        "||=" => "logic",
        "&&=" => "logic",
        "==" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "=" => "logic"
      },
      "char" => {
      },
      "number" => {
      },
      "decimal" => {
      },
      "string" => {
      }
    },
    "char" => {
      "logic" => {
      },
      "char" => {
        "!=" => "logic",
        "==" => "logic",
        "<=" => "logic",
        ">=" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "=" => "char",
        "<" => "logic",
        ">" => "logic"
      },
      "number" => {
      },
      "decimal" => {
      },
      "string" => {
      }
    },
    "number" => {
      "logic" => {
      },
      "char" => {
      },
      "number" => {
        "!=" => "logic",
        "+=" => "number",
        "-=" => "number",
        "*=" => "number",
        "/=" => "number",
        "%=" => "number",
        "==" => "logic",
        "<=" => "logic",
        ">=" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "%" => "number",
        "*" => "number",
        "/" => "number",
        "+" => "number",
        "-" => "number",
        "=" => "number",
        "<" => "logic",
        ">" => "logic"
      },
      "decimal" => {
        "!=" => "logic",
        "+=" => "number",
        "-=" => "number",
        "*=" => "number",
        "/=" => "number",
        "%=" => "number",
        "==" => "logic",
        "<=" => "logic",
        ">=" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "%" => "number",
        "*" => "number",
        "/" => "number",
        "+" => "number",
        "-" => "number",
        "=" => "number",
        "<" => "logic",
        ">" => "logic"
      },
      "string" => {
      }
    },
    "decimal" => {
      "logic" => {
      },
      "char" => {
      },
      "number" => {
        "!=" => "logic",
        "+=" => "number",
        "-=" => "number",
        "*=" => "number",
        "/=" => "number",
        "%=" => "number",
        "==" => "logic",
        "<=" => "logic",
        ">=" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "%" => "number",
        "*" => "number",
        "/" => "number",
        "+" => "number",
        "-" => "number",
        "=" => "number",
        "<" => "logic",
        ">" => "logic"
      },
      "decimal" => {
        "!=" => "logic",
        "+=" => "decimal",
        "-=" => "decimal",
        "*=" => "decimal",
        "/=" => "decimal",
        "%=" => "decimal",
        "==" => "logic",
        "<=" => "logic",
        ">=" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "%" => "decimal",
        "*" => "decimal",
        "/" => "decimal",
        "+" => "decimal",
        "-" => "decimal",
        "=" => "decimal",
        "<" => "logic",
        ">" => "logic"
      },
      "string" => {
      }
    },
    "string" => {
      "logic" => {
      },
      "char" => {
      },
      "number" => {
      },
      "decimal" => {
      },
      "string" => {
        "!=" => "logic",
        "==" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "=" => "string",
      }
    }
  }

---- inner

  # Se importa esta funcion perteneciente a la gema de racc. Se realiza una modificacion
  # Funcion que lee un archivo como entrada.
  def parse(input)
    scan_file(input)
  end

  # para poder desplegar la linea en la que se encuentra el error.
  def on_error(t, val, vstack)
    raise ParseError, sprintf("\nParsing error on value %s (%s) found on line: %i", val[0].inspect, token_to_str(t) || '?', $line_number)
  end

  def newSpecies(species)
    if $speciesBook[species] == nil
      $speciesBook[species] = Hash.new
      $speciesBook[species]["methods"] = Hash.new
      $speciesBook[species]["variables"] = Hash.new
      $speciesBook[species]["size"] = 0
      $actualSpecies = species
      $actualMethod = "species"
      resetCounters("global")
      puts "species #{species} successfully defined"
    else
      abort("Semantic error: species '#{species}' is already defined. Error on line: #{$line_number}")
    end
  end

  def heirSpecies(father)
    if $speciesBook[father] != nil
      $speciesBook[$actualSpecies]["father"] = $speciesBook[father]
      puts "successful heiring from #{father}"
    else
      abort("Semantic error: '#{father}' father of species '#{$actualSpecies}' is not defined. Error on line: #{$line_number}")
    end
  end

  def newVariable(id)
    if $actualMethod == "species"
      unless idDeclaredInSpeciesRecursively($speciesBook[$actualSpecies], id, "variables")
        unless isValidType($actualType)
          abort("Semantic error: species '#{$actualType}' is not defined. Error on line: #{$line_number}")
        end
        if $actualType == $actualSpecies
          abort("Semantic error: you cannot have recursive species definitions. Error on line: #{$line_number}")
        end
        $speciesBook[$actualSpecies]["variables"][id] = Hash.new
        $speciesBook[$actualSpecies]["variables"][id]["type"] = $actualType
        $speciesBook[$actualSpecies]["variables"][id]["scope"] = $actualModifier
        $speciesBook[$actualSpecies]["variables"][id]["modifiable"] = $isVariable
        if $actualType == "number" || $actualType == "decimal" || $actualType == "string" || $actualType == "char" || $actualType == "logic"
          $speciesBook[$actualSpecies]["variables"][id]["location"] = locationGenerator(1, "global", $actualType)
        end
      else
        abort("Semantic error: variable '#{id}' is already defined. Error on line: #{$line_number}")
      end
    else
      if $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id] == nil
        unless isValidType($actualType)
          abort("Semantic error: species '#{$actualType}' is not defined. Error on line: #{$line_number}")
        end
        $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id] = Hash.new
        $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["type"] = $actualType
        $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["modifiable"] = $isVariable
        if $actualType == "number" || $actualType == "decimal" || $actualType == "string" || $actualType == "char" || $actualType == "logic"
          $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["location"] = locationGenerator(1, "local", $actualType)
        end
      else
        abort("Semantic error: variable '#{id}' is already defined in method '#{$actualMethod}'. Error on line: #{$line_number}")
      end
    end
  end

  def idDeclaredInSpeciesRecursively(species, id, type)
    if species[type][id] != nil # regresa si la variable ya existe
      return true
    elsif species["father"] == nil  # si la clase no tiene padre
      return false
    else
      return idDeclaredInSpeciesRecursively(species["father"], id, type) # checa para su padre
    end
  end

  def isValidType(type)
    if type == "number" || type == "decimal" || type == "char" || type == "string" || type == "logic"
      return true
    else
      return $speciesBook[type] != nil # que no sea un hash vacio (valor por default)
    end
  end

  def newMethod(id)
    unless idDeclaredInSpeciesRecursively($speciesBook[$actualSpecies], id, "methods")
      unless isValidType($actualType) || $actualType == "oblivion"
        abort("Semantic error: species '#{$actualType}' is not defined. Error on line: #{$line_number}")
      end
      $speciesBook[$actualSpecies]["methods"][id] = Hash.new
      $speciesBook[$actualSpecies]["methods"][id]["type"] = $actualType
      $speciesBook[$actualSpecies]["methods"][id]["scope"] = $actualModifier
      $speciesBook[$actualSpecies]["methods"][id]["size"] = 0
      $speciesBook[$actualSpecies]["methods"][id]["variables"] = Hash.new
      $speciesBook[$actualSpecies]["methods"][id]["argumentList"] = []
      $actualMethod = id
      resetCounters("local")
    else
      abort("Semantic error: variable '#{id}' is already defined. Error on line: #{$line_number}")
    end
  end

  def newArgument(type, id)
    if $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id] == nil
      unless isValidType(type)
        abort("Semantic error: species '#{type}' is not defined. Error on line: #{$line_number}")
      end
      $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id] = Hash.new
      $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["type"] = $actualType
      $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["modifiable"] = $isVariable
      if $actualType == "number" || $actualType == "decimal" || $actualType == "string" || $actualType == "char" || $actualType == "logic"
        $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["location"] = locationGenerator(1, "local", $actualType)
      end
      $speciesBook[$actualSpecies]["methods"][$actualMethod]["argumentList"].push(type)
    else
      abort("Semantic error: argument '#{id}' is already defined in method '#{$actualMethod}'. Error on line: #{$line_number}")
    end
  end

  def validateExpression(opLeft, opRight, operator)
    if $semanticCube[opLeft][opRight][operator] == nil
      abort("Semantic error: incompatible types #{opLeft} and #{opRight} with operator #{operator}, or invalid operation. Error on line: #{$line_number}")
    end
    return $semanticCube[opLeft][opRight][operator]
  end

  def newConstant(type, value)
    if $constantBook[value] == nil
      $constantBook[value] = locationGenerator(1, "constant", type)
    end
  end

  def locationGenerator(size, scope, type)
    if $theMagicNumber - $magicCounter[scope][type] >= size
      location = $magicReference[scope][type] * $theMagicNumber + $magicCounter[scope][type]
      $magicCounter[scope][type] += size
      return location
    else
      abort("Compilation error: out of memory for a #{type} variable with the #{scope} scope. While compiling line: #{$line_number}")
    end
  end

  def resetCounters(scope)
    $magicCounter[scope]["number"] = 0
    $magicCounter[scope]["decimal"] = 0
    $magicCounter[scope]["string"] = 0
    $magicCounter[scope]["char"] = 0
    $magicCounter[scope]["logic"] = 0
  end

  def validateArithmeticExpression()
    if $operatorStack.top() == '*' || $operatorStack.top() == '/' ||
       $operatorStack.top() == '+' || $operatorStack.top() == '-' ||
       $operatorStack.top() == '%'
      op = $operatorStack.pop()
      rightOp = $operandStack.pop()
      leftOp = $operandStack.pop()
      createCuadruplo(op, rightOp, leftOp)
    end
  end

  def createCuadruplo(op, right, left)
    $vectorCuadruplo.push(op)
    $vectorCuadruplo.push(left)
    $vectorCuadruplo.push(right)
    $vectorCuadruplo.push() #Aqui falta mandar el temporal
  end
