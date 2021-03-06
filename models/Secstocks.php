<?php

namespace app\models;

/**
 * This is the model class for table "secstocks".
 *
 * @property int $id
 * @property string $cd
 * @property string $pe
 * @property string $ss
 * @property string $mp
 * @property int $uniforme_id
 *
 * @property Uniformes $uniforme
 */
class Secstocks extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'secstocks';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['cd', 'pe', 'ss', 'mp', 'uniforme_id'], 'required'],
            [['cd', 'pe', 'ss', 'mp'], 'integer'],
            [['uniforme_id'], 'default', 'value' => null],
            [['uniforme_id'], 'integer'],
            [['uniforme_id'], 'exist', 'skipOnError' => true, 'targetClass' => Uniformes::className(), 'targetAttribute' => ['uniforme_id' => 'id']],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'cd' => 'Consumo semanal',
            'pe' => 'Tiempo pedido(dias)',
            'ss' => 'Stock de seguridad',
            'mp' => 'Cantidad cuando pedir',
            'uniforme_id' => 'Uniforme ID',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getUniforme()
    {
        return $this->hasOne(Uniformes::className(), ['id' => 'uniforme_id'])->inverseOf('secstock');
    }
}
