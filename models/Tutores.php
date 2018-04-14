<?php

namespace app\models;

/**
 * This is the model class for table "tutores".
 *
 * @property int $id
 * @property string $nif
 * @property string $nombre
 * @property string $apellidos
 * @property string $direccion
 * @property string $telefono
 * @property string $email
 * @property int $colegio_id
 *
 * @property Alumnos[] $alumnos
 * @property Alumnos[] $alumnos0
 * @property Colegios $colegio
 */
class Tutores extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'tutores';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['nif', 'nombre', 'apellidos', 'direccion', 'telefono', 'email', 'colegio_id'], 'required'],
            [['telefono'], 'number'],
            [['colegio_id'], 'default', 'value' => null],
            [['colegio_id'], 'integer'],
            [['nif'], 'string', 'max' => 9],
            [['nombre', 'apellidos', 'direccion', 'email'], 'string', 'max' => 255],
            [['colegio_id'], 'exist', 'skipOnError' => true, 'targetClass' => Colegios::className(), 'targetAttribute' => ['colegio_id' => 'id']],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'nif' => 'Nif',
            'nombre' => 'Nombre',
            'apellidos' => 'Apellidos',
            'direccion' => 'Direccion',
            'telefono' => 'Telefono',
            'email' => 'Email',
            'colegio_id' => 'Colegio ID',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getAlumnos()
    {
        return $this->hasMany(Alumnos::className(), ['tutor_id' => 'id'])->inverseOf('tutor');
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getAlumnos0()
    {
        return $this->hasMany(Alumnos::className(), ['tutor2_id' => 'id'])->inverseOf('tutor2');
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getColegio()
    {
        return $this->hasOne(Colegios::className(), ['id' => 'colegio_id'])->inverseOf('tutores');
    }
}
