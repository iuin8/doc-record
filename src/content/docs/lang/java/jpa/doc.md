# jpa使用记录

## jsonb类型筛选相关

```java

// CommodityDO.java
    /**
     * 适用车型
     */
    @Convert(converter = JpaJsonToListStringConverter.class)
    @Column(columnDefinition = "jsonb")
    @Comment("适用车型")
    private List<String> suitableCarModels = new ArrayList<>();

    /**
     * 适用车型(虚拟字段, 用于筛选)
     * @see CommodityDO#suitableCarModels @Formula的值得是这个字段的小写形式
     */
    @Formula("suitable_car_models::text")
    private String suitableCarModelsText;

// xxxCommodityImpl.java

    // 适用车型筛选
    if (!CollectionUtils.isEmpty(CollUtil.removeBlank(suitableCarModels))) {

        Set<BooleanExpression> booleanExpressionSet = suitableCarModels.stream().map(
                str -> commodityDO.suitableCarModelsText.like(StrUtil.wrap(str, "%\"", "\"%"))
        ).collect(Collectors.toSet());

        booleanExpressionSet.add(commodityDO.isSuitableAllCarModel.isTrue());

        BooleanExpression finalCondition = Expressions.anyOf(
                booleanExpressionSet.toArray(BooleanExpression[]::new)
        );

        predicates.and(finalCondition);
    }

```
