import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Categoria {
  huevos, pasta, queso, cerdo, ternera, pollo, pavo,
  vegetariano, marisco, verdura, algas, fruta, lacteo,
  pescado, conservas, legumbres, bebidas, cereales,
  secos, bayas, otros, cordero, pato, conejo,
}

class Ingredient {
  final String name;
  final double caloriesPer100g;
  final double proteinPer100g;
  final Categoria categoria;

  Ingredient({
    required this.name,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.categoria,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'caloriesPer100g': caloriesPer100g,
    'proteinPer100g': proteinPer100g,
    'categoria': categoria.name,
  };

  Map<String, dynamic> toMap() => toJson();

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] as String,
      caloriesPer100g: (json['caloriesPer100g'] as num).toDouble(),
      proteinPer100g: (json['proteinPer100g'] as num).toDouble(),
      categoria: Categoria.values.firstWhere(
        (c) => c.name == json['categoria'] as String,
        orElse: () => Categoria.otros,
      ),
    );
  }

static String getCategoriaText(Categoria categoria, AppLocalizations loc) {
  switch (categoria) {
    case Categoria.huevos:
      return loc.categoriaHuevos;
    case Categoria.pasta:
      return loc.categoriaPasta;
    case Categoria.queso:
      return loc.categoriaQueso;
    case Categoria.cerdo:
      return loc.categoriaCerdo;
    case Categoria.ternera:
      return loc.categoriaTernera;
    case Categoria.pollo:
      return loc.categoriaPollo;
    case Categoria.pavo:
      return loc.categoriaPavo;
    case Categoria.vegetariano:
      return loc.categoriaVegetariano;
    case Categoria.marisco:
      return loc.categoriaMarisco;
    case Categoria.verdura:
      return loc.categoriaVerdura;
    case Categoria.algas:
      return loc.categoriaAlgas;
    case Categoria.fruta:
      return loc.categoriaFruta;
    case Categoria.lacteo:
      return loc.categoriaLacteo;
    case Categoria.pescado:
      return loc.categoriaPescado;
    case Categoria.conservas:
      return loc.categoriaConservas;
    case Categoria.legumbres:
      return loc.categoriaLegumbres;
    case Categoria.bebidas:
      return loc.categoriaBebidas;
    case Categoria.cereales:
      return loc.categoriaCereales;
    case Categoria.secos:
      return loc.categoriaSecos;
    case Categoria.bayas:
      return loc.categoriaBayas;
    case Categoria.otros:
      return loc.categoriaOtros;
    case Categoria.cordero:              
      return loc.categoriaCordero;
    case Categoria.pato:                 
      return loc.categoriaPato;
    case Categoria.conejo:               
      return loc.categoriaConejo;
  }
}
}
