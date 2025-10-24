import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import 'widgets/banner_ad_widget.dart';
import 'widgets/interstitial_ad_manager.dart';
import 'package:nuevo_proyecto/models/custom_meal.dart' as meal_model;
import 'package:nuevo_proyecto/models/ingredient.dart' show Ingredient, Categoria;
import 'package:nuevo_proyecto/services/firestore_saved_meals_service.dart' as saved_meals_service;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Ingredient> getMainIngredients(BuildContext context, String mode) {
  return [
        Ingredient(name: AppLocalizations.of(context)!.ingredientJamonSerrano, caloriesPer100g: 241, proteinPer100g: 33, categoria: Categoria.cerdo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientJamonYork, caloriesPer100g: 126, proteinPer100g: 20,categoria: Categoria.cerdo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFiambreDePavo, caloriesPer100g: 110, proteinPer100g: 22, categoria: Categoria.pavo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLomoEmbuchado, caloriesPer100g: 250, proteinPer100g: 35, categoria: Categoria.cerdo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientHuevosAlaPlancha, caloriesPer100g: 155, proteinPer100g: 13, categoria: Categoria.huevos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientHuevosRevueltos, caloriesPer100g: 150, proteinPer100g: 10, categoria: Categoria.huevos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientHuevosCocidos, caloriesPer100g: 155, proteinPer100g: 11, categoria: Categoria.huevos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientOmelette, caloriesPer100g: 150, proteinPer100g: 10, categoria: Categoria.huevos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientOmeletteDeClaras, caloriesPer100g: 52, proteinPer100g: 11, categoria: Categoria.huevos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientQuesoFresco, caloriesPer100g: 100, proteinPer100g: 11, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientQuesoCottage, caloriesPer100g: 98, proteinPer100g: 12, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientQuesoEdam, caloriesPer100g: 357, proteinPer100g: 25, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientSalmonAhumado, caloriesPer100g: 117, proteinPer100g: 19, categoria: Categoria.conservas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientAtunEnLataNatural, caloriesPer100g: 116, proteinPer100g: 26, categoria: Categoria.conservas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCarnePicadaTernera, caloriesPer100g: 215, proteinPer100g: 26, categoria: Categoria.ternera),
        Ingredient(name: AppLocalizations.of(context)!.ingredientSolomilloTernera, caloriesPer100g: 160, proteinPer100g: 22, categoria: Categoria.ternera),
        Ingredient(name: AppLocalizations.of(context)!.ingredientEntrecotTernera, caloriesPer100g: 260, proteinPer100g: 23, categoria: Categoria.ternera),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBistecTernera, caloriesPer100g: 180, proteinPer100g: 22, categoria: Categoria.ternera),
        Ingredient(name: AppLocalizations.of(context)!.ingredientHigadoTernera, caloriesPer100g: 135, proteinPer100g: 21, categoria: Categoria.ternera),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMuslosPollo, caloriesPer100g: 210, proteinPer100g: 20, categoria: Categoria.pollo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPechugaPollo, caloriesPer100g: 165, proteinPer100g: 23, categoria: Categoria.pollo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCarnePavo, caloriesPer100g: 135, proteinPer100g: 23, categoria: Categoria.pavo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCabezaLomoCerdo, caloriesPer100g: 230, proteinPer100g: 20, categoria: Categoria.cerdo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientSolomilloCerdo, caloriesPer100g: 140, proteinPer100g: 22, categoria: Categoria.cerdo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientChuletasCerdo, caloriesPer100g: 250, proteinPer100g: 20, categoria: Categoria.cerdo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLomoCerdo, caloriesPer100g: 240, proteinPer100g: 21, categoria: Categoria.cerdo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMozzarellaBufala, caloriesPer100g: 280, proteinPer100g: 20, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBurrata, caloriesPer100g: 330, proteinPer100g: 14, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientGarbanzos, caloriesPer100g: 164, proteinPer100g: 8, categoria: Categoria.legumbres),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLentejasCocidas, caloriesPer100g: 116, proteinPer100g: 8, categoria: Categoria.legumbres),
        Ingredient(name: AppLocalizations.of(context)!.ingredientJudiasBlancasCocidas, caloriesPer100g: 127, proteinPer100g: 7, categoria: Categoria.legumbres),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFrijolesRojosCocidos, caloriesPer100g: 127, proteinPer100g: 8, categoria: Categoria.legumbres),
        Ingredient(name: AppLocalizations.of(context)!.ingredientSalmonFresco, caloriesPer100g: 200, proteinPer100g: 20, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientAtunFresco, caloriesPer100g: 108, proteinPer100g: 23, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMerluza, caloriesPer100g: 85, proteinPer100g: 18,categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBacalao, caloriesPer100g: 82, proteinPer100g: 18, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCorvina, caloriesPer100g: 95, proteinPer100g: 20, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientSardinas, caloriesPer100g: 208, proteinPer100g: 23, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCaballa, caloriesPer100g: 305, proteinPer100g: 19, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLubina, caloriesPer100g: 97, proteinPer100g: 18, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientDorada, caloriesPer100g: 110, proteinPer100g: 20, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPanga, caloriesPer100g: 65, proteinPer100g: 16, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCalamar, caloriesPer100g: 92, proteinPer100g: 15, categoria: Categoria.marisco),
        Ingredient(name: AppLocalizations.of(context)!.ingredientSepia, caloriesPer100g: 79, proteinPer100g: 16, categoria: Categoria.marisco),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPulpo, caloriesPer100g: 82, proteinPer100g: 15, categoria: Categoria.marisco),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMejillones, caloriesPer100g: 150, proteinPer100g: 13, categoria: Categoria.marisco),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLangostinos, caloriesPer100g: 99, proteinPer100g: 19, categoria: Categoria.marisco),
        Ingredient(name: AppLocalizations.of(context)!.ingredientZumoDeNaranja, caloriesPer100g: 45, proteinPer100g: 0.7, categoria: Categoria.bebidas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLecheEntera, caloriesPer100g: 64, proteinPer100g: 3.3, categoria: Categoria.lacteo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLecheSemidesnatada, caloriesPer100g: 50, proteinPer100g: 3.4, categoria: Categoria.lacteo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLecheDesnatada, caloriesPer100g: 35, proteinPer100g: 3.4, categoria: Categoria.lacteo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLecheSinLactosa, caloriesPer100g: 64, proteinPer100g: 3.3, categoria: Categoria.lacteo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBebidaDeAvena, caloriesPer100g: 50, proteinPer100g: 1.0, categoria: Categoria.bebidas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBebidaDeSoja, caloriesPer100g: 35, proteinPer100g: 3.3, categoria: Categoria.bebidas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBebidaDeArroz, caloriesPer100g: 47, proteinPer100g: 0.5, categoria: Categoria.bebidas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientProteinaPolvo, caloriesPer100g: 400, proteinPer100g: 90, categoria: Categoria.bebidas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientGranola, caloriesPer100g: 471, proteinPer100g: 10, categoria: Categoria.cereales),
        Ingredient(name: AppLocalizations.of(context)!.ingredientQuesoCrema, caloriesPer100g: 342, proteinPer100g: 6, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientQuesoCremaLight, caloriesPer100g: 240, proteinPer100g: 7, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientYogurGriego, caloriesPer100g: 59, proteinPer100g: 10, categoria: Categoria.lacteo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientKefir, caloriesPer100g: 50, proteinPer100g: 3, categoria: Categoria.lacteo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientAvenaCruda, caloriesPer100g: 375, proteinPer100g: 17, categoria: Categoria.cereales),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPanDeMoldeIntegral, caloriesPer100g: 250, proteinPer100g: 11, categoria: Categoria.cereales),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPanDeMoldeBlanco, caloriesPer100g: 265, proteinPer100g: 8, categoria: Categoria.cereales),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMargarina, caloriesPer100g: 717, proteinPer100g: 0.2, categoria: Categoria.vegetariano),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMantequilla, caloriesPer100g: 717, proteinPer100g: 0.5, categoria: Categoria.lacteo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCremaDeCacahuete, caloriesPer100g: 588, proteinPer100g: 26, categoria: Categoria.otros),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMermeladaSinAzucar, caloriesPer100g: 20, proteinPer100g: 0.3, categoria: Categoria.otros),
        Ingredient(name: AppLocalizations.of(context)!.ingredientAguacate, caloriesPer100g: 160, proteinPer100g: 2, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientTomate, caloriesPer100g: 18, proteinPer100g: 0.9, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientUvas, caloriesPer100g: 69, proteinPer100g: 0.7, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMandarinas, caloriesPer100g: 53, proteinPer100g: 0.8, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBanana, caloriesPer100g: 89, proteinPer100g: 1.1, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientManzana, caloriesPer100g: 52, proteinPer100g: 0.3, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFresas, caloriesPer100g: 33, proteinPer100g: 0.8, categoria: Categoria.bayas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFrambuesas, caloriesPer100g: 52, proteinPer100g: 1.2, categoria: Categoria.bayas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientArandanos, caloriesPer100g: 57, proteinPer100g: 0.7, categoria: Categoria.bayas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMoras, caloriesPer100g: 43, proteinPer100g: 1.4, categoria: Categoria.bayas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPapaya, caloriesPer100g: 43, proteinPer100g: 0.5, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientSandia, caloriesPer100g: 30, proteinPer100g: 0.6, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMelon, caloriesPer100g: 34, proteinPer100g: 0.8, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPina, caloriesPer100g: 50, proteinPer100g: 0.5, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMango, caloriesPer100g: 60, proteinPer100g: 0.8, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientDatiles, caloriesPer100g: 282, proteinPer100g: 2, categoria: Categoria.secos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientNueces, caloriesPer100g: 654, proteinPer100g: 15, categoria: Categoria.secos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPistachos, caloriesPer100g: 562, proteinPer100g: 20, categoria: Categoria.secos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientAlmendrasCrudas, caloriesPer100g: 579, proteinPer100g: 21, categoria: Categoria.secos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientAnacardos, caloriesPer100g: 553, proteinPer100g: 18, categoria: Categoria.secos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPanDeHamburguesa, caloriesPer100g: 265, proteinPer100g: 8, categoria: Categoria.cereales),
        Ingredient(name: AppLocalizations.of(context)!.ingredientArrozBlancoCocido, caloriesPer100g: 130, proteinPer100g: 2.4, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientArrozBasmatiCocido, caloriesPer100g: 130, proteinPer100g: 2.5, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPastaCocida, caloriesPer100g: 131, proteinPer100g: 6,categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientParmesanoRallado, caloriesPer100g: 431, proteinPer100g: 38,  categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMozzarellaRallada, caloriesPer100g: 280, proteinPer100g: 24,  categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientSeitan, caloriesPer100g: 120, proteinPer100g: 25, categoria: Categoria.vegetariano),
        Ingredient(name: AppLocalizations.of(context)!.ingredientTofu, caloriesPer100g: 76, proteinPer100g: 9, categoria: Categoria.vegetariano),
        Ingredient(name: AppLocalizations.of(context)!.ingredientQuinoaCocida, caloriesPer100g: 120, proteinPer100g: 4, categoria: Categoria.vegetariano),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCousCousCocido, caloriesPer100g: 112, proteinPer100g: 3.8, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPatataCocida, caloriesPer100g: 86, proteinPer100g: 2, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBoniatoCocido, caloriesPer100g: 90, proteinPer100g: 2, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientYuca, caloriesPer100g: 160, proteinPer100g: 1.4, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientGuisantes, caloriesPer100g: 84, proteinPer100g: 5.4, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientJudiasVerdes, caloriesPer100g: 31, proteinPer100g: 1.8, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCol, caloriesPer100g: 25, proteinPer100g: 1.3, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBrocoli, caloriesPer100g: 55, proteinPer100g: 3, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientColiflor, caloriesPer100g: 25, proteinPer100g: 2, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientEspinacas, caloriesPer100g: 23, proteinPer100g: 2.5, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCalabacin, caloriesPer100g: 17, proteinPer100g: 1, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientEsparragos, caloriesPer100g: 20, proteinPer100g: 2, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBerenjena, caloriesPer100g: 25, proteinPer100g: 1, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientChampinones, caloriesPer100g: 22, proteinPer100g: 3, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCalabaza, caloriesPer100g: 26, proteinPer100g: 1, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientAlcachofas, caloriesPer100g: 47, proteinPer100g: 3.3, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientHabas, caloriesPer100g: 110, proteinPer100g: 7, categoria: Categoria.legumbres),
        Ingredient(name: AppLocalizations.of(context)!.ingredientGoji, caloriesPer100g: 349, proteinPer100g: 14, categoria: Categoria.bayas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientNori, caloriesPer100g: 35, proteinPer100g: 5.8, categoria: Categoria.algas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientWakame, caloriesPer100g: 45, proteinPer100g: 3, categoria: Categoria.algas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientShiitake, caloriesPer100g: 34, proteinPer100g: 2.2, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientEnoki, caloriesPer100g: 37, proteinPer100g: 2.7, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBambu, caloriesPer100g: 27, proteinPer100g: 2.6, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientKombu, caloriesPer100g: 20, proteinPer100g: 1.7, categoria: Categoria.algas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFideosDeArroz, caloriesPer100g: 110, proteinPer100g: 2.4, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFideosUdon, caloriesPer100g: 127, proteinPer100g: 5, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientArrozIntegral, caloriesPer100g: 111, proteinPer100g: 2.6, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPastaIntegral, caloriesPer100g: 130, proteinPer100g: 5.0, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFideosArrozIntegral, caloriesPer100g: 120, proteinPer100g: 3.0, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFideosUdonIntegral, caloriesPer100g: 130, proteinPer100g: 4.0, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientClarasPasteurizadas, caloriesPer100g: 50, proteinPer100g: 11, categoria: Categoria.huevos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientHuevosCodorniz, caloriesPer100g: 158, proteinPer100g: 13, categoria: Categoria.huevos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCarneCorderoMagra, caloriesPer100g: 175, proteinPer100g: 23, categoria: Categoria.cordero),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPechugaPato, caloriesPer100g: 240, proteinPer100g: 19, categoria: Categoria.pato),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCarneConejo, caloriesPer100g: 173, proteinPer100g: 21, categoria: Categoria.conejo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientTruchaArcoiris, caloriesPer100g: 148, proteinPer100g: 19, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientVieiras, caloriesPer100g: 69, proteinPer100g: 12, categoria: Categoria.marisco),
        Ingredient(name: AppLocalizations.of(context)!.ingredientQuesoManchegoSemicurado, caloriesPer100g: 380, proteinPer100g: 26, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientRicotta, caloriesPer100g: 174, proteinPer100g: 11, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientQuesoFetaLight, caloriesPer100g: 255, proteinPer100g: 14, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientHummus, caloriesPer100g: 160, proteinPer100g: 8, categoria: Categoria.legumbres),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMijoCocido, caloriesPer100g: 119, proteinPer100g: 4, categoria: Categoria.cereales),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPanCentenoIntegral, caloriesPer100g: 259, proteinPer100g: 9, categoria: Categoria.cereales),
        Ingredient(name: AppLocalizations.of(context)!.ingredientKiwi, caloriesPer100g: 61, proteinPer100g: 1.1, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFrutosBosqueMixtos, caloriesPer100g: 45, proteinPer100g: 1, categoria: Categoria.bayas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientGranada, caloriesPer100g: 83, proteinPer100g: 1.7, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientKefirCabra, caloriesPer100g: 95, proteinPer100g: 3.8, categoria: Categoria.lacteo),
      ];
}
List<Ingredient> getSideIngredients(BuildContext context, String mode) {
  return [
        Ingredient(name: AppLocalizations.of(context)!.ingredientJamonSerrano, caloriesPer100g: 241, proteinPer100g: 33, categoria: Categoria.cerdo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientJamonYork, caloriesPer100g: 126, proteinPer100g: 20,categoria: Categoria.cerdo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFiambreDePavo, caloriesPer100g: 110, proteinPer100g: 22, categoria: Categoria.pavo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLomoEmbuchado, caloriesPer100g: 250, proteinPer100g: 35, categoria: Categoria.cerdo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientHuevosAlaPlancha, caloriesPer100g: 155, proteinPer100g: 13, categoria: Categoria.huevos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientHuevosRevueltos, caloriesPer100g: 150, proteinPer100g: 10, categoria: Categoria.huevos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientHuevosCocidos, caloriesPer100g: 155, proteinPer100g: 11, categoria: Categoria.huevos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientOmelette, caloriesPer100g: 150, proteinPer100g: 10, categoria: Categoria.huevos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientOmeletteDeClaras, caloriesPer100g: 52, proteinPer100g: 11, categoria: Categoria.huevos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientQuesoFresco, caloriesPer100g: 100, proteinPer100g: 11, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientQuesoCottage, caloriesPer100g: 98, proteinPer100g: 12, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientQuesoEdam, caloriesPer100g: 357, proteinPer100g: 25, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientSalmonAhumado, caloriesPer100g: 117, proteinPer100g: 19, categoria: Categoria.conservas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientAtunEnLataNatural, caloriesPer100g: 116, proteinPer100g: 26, categoria: Categoria.conservas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCarnePicadaTernera, caloriesPer100g: 215, proteinPer100g: 26, categoria: Categoria.ternera),
        Ingredient(name: AppLocalizations.of(context)!.ingredientSolomilloTernera, caloriesPer100g: 160, proteinPer100g: 22, categoria: Categoria.ternera),
        Ingredient(name: AppLocalizations.of(context)!.ingredientEntrecotTernera, caloriesPer100g: 260, proteinPer100g: 23, categoria: Categoria.ternera),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBistecTernera, caloriesPer100g: 180, proteinPer100g: 22, categoria: Categoria.ternera),
        Ingredient(name: AppLocalizations.of(context)!.ingredientHigadoTernera, caloriesPer100g: 135, proteinPer100g: 21, categoria: Categoria.ternera),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMuslosPollo, caloriesPer100g: 210, proteinPer100g: 20, categoria: Categoria.pollo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPechugaPollo, caloriesPer100g: 165, proteinPer100g: 23, categoria: Categoria.pollo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCarnePavo, caloriesPer100g: 135, proteinPer100g: 23, categoria: Categoria.pavo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCabezaLomoCerdo, caloriesPer100g: 230, proteinPer100g: 20, categoria: Categoria.cerdo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientSolomilloCerdo, caloriesPer100g: 140, proteinPer100g: 22, categoria: Categoria.cerdo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientChuletasCerdo, caloriesPer100g: 250, proteinPer100g: 20, categoria: Categoria.cerdo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLomoCerdo, caloriesPer100g: 240, proteinPer100g: 21, categoria: Categoria.cerdo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMozzarellaBufala, caloriesPer100g: 280, proteinPer100g: 20, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBurrata, caloriesPer100g: 330, proteinPer100g: 14, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientGarbanzos, caloriesPer100g: 164, proteinPer100g: 8, categoria: Categoria.legumbres),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLentejasCocidas, caloriesPer100g: 116, proteinPer100g: 8, categoria: Categoria.legumbres),
        Ingredient(name: AppLocalizations.of(context)!.ingredientJudiasBlancasCocidas, caloriesPer100g: 127, proteinPer100g: 7, categoria: Categoria.legumbres),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFrijolesRojosCocidos, caloriesPer100g: 127, proteinPer100g: 8, categoria: Categoria.legumbres),
        Ingredient(name: AppLocalizations.of(context)!.ingredientSalmonFresco, caloriesPer100g: 200, proteinPer100g: 20, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientAtunFresco, caloriesPer100g: 108, proteinPer100g: 23, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMerluza, caloriesPer100g: 85, proteinPer100g: 18,categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBacalao, caloriesPer100g: 82, proteinPer100g: 18, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCorvina, caloriesPer100g: 95, proteinPer100g: 20, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientSardinas, caloriesPer100g: 208, proteinPer100g: 23, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCaballa, caloriesPer100g: 305, proteinPer100g: 19, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLubina, caloriesPer100g: 97, proteinPer100g: 18, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientDorada, caloriesPer100g: 110, proteinPer100g: 20, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPanga, caloriesPer100g: 65, proteinPer100g: 16, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCalamar, caloriesPer100g: 92, proteinPer100g: 15, categoria: Categoria.marisco),
        Ingredient(name: AppLocalizations.of(context)!.ingredientSepia, caloriesPer100g: 79, proteinPer100g: 16, categoria: Categoria.marisco),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPulpo, caloriesPer100g: 82, proteinPer100g: 15, categoria: Categoria.marisco),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMejillones, caloriesPer100g: 150, proteinPer100g: 13, categoria: Categoria.marisco),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLangostinos, caloriesPer100g: 99, proteinPer100g: 19, categoria: Categoria.marisco),
        Ingredient(name: AppLocalizations.of(context)!.ingredientZumoDeNaranja, caloriesPer100g: 45, proteinPer100g: 0.7, categoria: Categoria.bebidas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLecheEntera, caloriesPer100g: 64, proteinPer100g: 3.3, categoria: Categoria.lacteo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLecheSemidesnatada, caloriesPer100g: 50, proteinPer100g: 3.4, categoria: Categoria.lacteo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLecheDesnatada, caloriesPer100g: 35, proteinPer100g: 3.4, categoria: Categoria.lacteo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientLecheSinLactosa, caloriesPer100g: 64, proteinPer100g: 3.3, categoria: Categoria.lacteo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBebidaDeAvena, caloriesPer100g: 50, proteinPer100g: 1.0, categoria: Categoria.bebidas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBebidaDeSoja, caloriesPer100g: 35, proteinPer100g: 3.3, categoria: Categoria.bebidas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBebidaDeArroz, caloriesPer100g: 47, proteinPer100g: 0.5, categoria: Categoria.bebidas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientProteinaPolvo, caloriesPer100g: 400, proteinPer100g: 90, categoria: Categoria.bebidas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientGranola, caloriesPer100g: 471, proteinPer100g: 10, categoria: Categoria.cereales),
        Ingredient(name: AppLocalizations.of(context)!.ingredientQuesoCrema, caloriesPer100g: 342, proteinPer100g: 6, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientQuesoCremaLight, caloriesPer100g: 240, proteinPer100g: 7, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientYogurGriego, caloriesPer100g: 59, proteinPer100g: 10, categoria: Categoria.lacteo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientKefir, caloriesPer100g: 50, proteinPer100g: 3, categoria: Categoria.lacteo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientAvenaCruda, caloriesPer100g: 375, proteinPer100g: 17, categoria: Categoria.cereales),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPanDeMoldeIntegral, caloriesPer100g: 250, proteinPer100g: 11, categoria: Categoria.cereales),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPanDeMoldeBlanco, caloriesPer100g: 265, proteinPer100g: 8, categoria: Categoria.cereales),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMargarina, caloriesPer100g: 717, proteinPer100g: 0.2, categoria: Categoria.vegetariano),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMantequilla, caloriesPer100g: 717, proteinPer100g: 0.5, categoria: Categoria.lacteo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCremaDeCacahuete, caloriesPer100g: 588, proteinPer100g: 26, categoria: Categoria.otros),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMermeladaSinAzucar, caloriesPer100g: 20, proteinPer100g: 0.3, categoria: Categoria.otros),
        Ingredient(name: AppLocalizations.of(context)!.ingredientAguacate, caloriesPer100g: 160, proteinPer100g: 2, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientTomate, caloriesPer100g: 18, proteinPer100g: 0.9, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientUvas, caloriesPer100g: 69, proteinPer100g: 0.7, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMandarinas, caloriesPer100g: 53, proteinPer100g: 0.8, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBanana, caloriesPer100g: 89, proteinPer100g: 1.1, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientManzana, caloriesPer100g: 52, proteinPer100g: 0.3, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFresas, caloriesPer100g: 33, proteinPer100g: 0.8, categoria: Categoria.bayas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFrambuesas, caloriesPer100g: 52, proteinPer100g: 1.2, categoria: Categoria.bayas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientArandanos, caloriesPer100g: 57, proteinPer100g: 0.7, categoria: Categoria.bayas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMoras, caloriesPer100g: 43, proteinPer100g: 1.4, categoria: Categoria.bayas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPapaya, caloriesPer100g: 43, proteinPer100g: 0.5, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientSandia, caloriesPer100g: 30, proteinPer100g: 0.6, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMelon, caloriesPer100g: 34, proteinPer100g: 0.8, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPina, caloriesPer100g: 50, proteinPer100g: 0.5, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMango, caloriesPer100g: 60, proteinPer100g: 0.8, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientDatiles, caloriesPer100g: 282, proteinPer100g: 2, categoria: Categoria.secos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientNueces, caloriesPer100g: 654, proteinPer100g: 15, categoria: Categoria.secos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPistachos, caloriesPer100g: 562, proteinPer100g: 20, categoria: Categoria.secos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientAlmendrasCrudas, caloriesPer100g: 579, proteinPer100g: 21, categoria: Categoria.secos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientAnacardos, caloriesPer100g: 553, proteinPer100g: 18, categoria: Categoria.secos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPanDeHamburguesa, caloriesPer100g: 265, proteinPer100g: 8, categoria: Categoria.cereales),
        Ingredient(name: AppLocalizations.of(context)!.ingredientArrozBlancoCocido, caloriesPer100g: 130, proteinPer100g: 2.4, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientArrozBasmatiCocido, caloriesPer100g: 130, proteinPer100g: 2.5, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPastaCocida, caloriesPer100g: 131, proteinPer100g: 6,categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientParmesanoRallado, caloriesPer100g: 431, proteinPer100g: 38,  categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMozzarellaRallada, caloriesPer100g: 280, proteinPer100g: 24,  categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientSeitan, caloriesPer100g: 120, proteinPer100g: 25, categoria: Categoria.vegetariano),
        Ingredient(name: AppLocalizations.of(context)!.ingredientTofu, caloriesPer100g: 76, proteinPer100g: 9, categoria: Categoria.vegetariano),
        Ingredient(name: AppLocalizations.of(context)!.ingredientQuinoaCocida, caloriesPer100g: 120, proteinPer100g: 4, categoria: Categoria.vegetariano),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCousCousCocido, caloriesPer100g: 112, proteinPer100g: 3.8, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPatataCocida, caloriesPer100g: 86, proteinPer100g: 2, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBoniatoCocido, caloriesPer100g: 90, proteinPer100g: 2, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientYuca, caloriesPer100g: 160, proteinPer100g: 1.4, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientGuisantes, caloriesPer100g: 84, proteinPer100g: 5.4, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientJudiasVerdes, caloriesPer100g: 31, proteinPer100g: 1.8, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCol, caloriesPer100g: 25, proteinPer100g: 1.3, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBrocoli, caloriesPer100g: 55, proteinPer100g: 3, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientColiflor, caloriesPer100g: 25, proteinPer100g: 2, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientEspinacas, caloriesPer100g: 23, proteinPer100g: 2.5, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCalabacin, caloriesPer100g: 17, proteinPer100g: 1, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientEsparragos, caloriesPer100g: 20, proteinPer100g: 2, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBerenjena, caloriesPer100g: 25, proteinPer100g: 1, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientChampinones, caloriesPer100g: 22, proteinPer100g: 3, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCalabaza, caloriesPer100g: 26, proteinPer100g: 1, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientAlcachofas, caloriesPer100g: 47, proteinPer100g: 3.3, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientHabas, caloriesPer100g: 110, proteinPer100g: 7, categoria: Categoria.legumbres),
        Ingredient(name: AppLocalizations.of(context)!.ingredientGoji, caloriesPer100g: 349, proteinPer100g: 14, categoria: Categoria.bayas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientNori, caloriesPer100g: 35, proteinPer100g: 5.8, categoria: Categoria.algas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientWakame, caloriesPer100g: 45, proteinPer100g: 3, categoria: Categoria.algas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientShiitake, caloriesPer100g: 34, proteinPer100g: 2.2, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientEnoki, caloriesPer100g: 37, proteinPer100g: 2.7, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientBambu, caloriesPer100g: 27, proteinPer100g: 2.6, categoria: Categoria.verdura),
        Ingredient(name: AppLocalizations.of(context)!.ingredientKombu, caloriesPer100g: 20, proteinPer100g: 1.7, categoria: Categoria.algas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFideosDeArroz, caloriesPer100g: 110, proteinPer100g: 2.4, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFideosUdon, caloriesPer100g: 127, proteinPer100g: 5, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientArrozIntegral, caloriesPer100g: 111, proteinPer100g: 2.6, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPastaIntegral, caloriesPer100g: 130, proteinPer100g: 5.0, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFideosArrozIntegral, caloriesPer100g: 120, proteinPer100g: 3.0, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFideosUdonIntegral, caloriesPer100g: 130, proteinPer100g: 4.0, categoria: Categoria.pasta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientClarasPasteurizadas, caloriesPer100g: 50, proteinPer100g: 11, categoria: Categoria.huevos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientHuevosCodorniz, caloriesPer100g: 158, proteinPer100g: 13, categoria: Categoria.huevos),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCarneCorderoMagra, caloriesPer100g: 175, proteinPer100g: 23, categoria: Categoria.cordero),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPechugaPato, caloriesPer100g: 240, proteinPer100g: 19, categoria: Categoria.pato),
        Ingredient(name: AppLocalizations.of(context)!.ingredientCarneConejo, caloriesPer100g: 173, proteinPer100g: 21, categoria: Categoria.conejo),
        Ingredient(name: AppLocalizations.of(context)!.ingredientTruchaArcoiris, caloriesPer100g: 148, proteinPer100g: 19, categoria: Categoria.pescado),
        Ingredient(name: AppLocalizations.of(context)!.ingredientVieiras, caloriesPer100g: 69, proteinPer100g: 12, categoria: Categoria.marisco),
        Ingredient(name: AppLocalizations.of(context)!.ingredientQuesoManchegoSemicurado, caloriesPer100g: 380, proteinPer100g: 26, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientRicotta, caloriesPer100g: 174, proteinPer100g: 11, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientQuesoFetaLight, caloriesPer100g: 255, proteinPer100g: 14, categoria: Categoria.queso),
        Ingredient(name: AppLocalizations.of(context)!.ingredientHummus, caloriesPer100g: 160, proteinPer100g: 8, categoria: Categoria.legumbres),
        Ingredient(name: AppLocalizations.of(context)!.ingredientMijoCocido, caloriesPer100g: 119, proteinPer100g: 4, categoria: Categoria.cereales),
        Ingredient(name: AppLocalizations.of(context)!.ingredientPanCentenoIntegral, caloriesPer100g: 259, proteinPer100g: 9, categoria: Categoria.cereales),
        Ingredient(name: AppLocalizations.of(context)!.ingredientKiwi, caloriesPer100g: 61, proteinPer100g: 1.1, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientFrutosBosqueMixtos, caloriesPer100g: 45, proteinPer100g: 1, categoria: Categoria.bayas),
        Ingredient(name: AppLocalizations.of(context)!.ingredientGranada, caloriesPer100g: 83, proteinPer100g: 1.7, categoria: Categoria.fruta),
        Ingredient(name: AppLocalizations.of(context)!.ingredientKefirCabra, caloriesPer100g: 95, proteinPer100g: 3.8, categoria: Categoria.lacteo),
      ];
}
String getCategoriaText(Categoria categoria, AppLocalizations localizations) {
  switch (categoria) {
    case Categoria.huevos: return localizations.categoriaHuevos;
    case Categoria.pasta: return localizations.categoriaPasta;
    case Categoria.queso: return localizations.categoriaQueso;
    case Categoria.cerdo: return localizations.categoriaCerdo;
    case Categoria.ternera: return localizations.categoriaTernera;
    case Categoria.pollo: return localizations.categoriaPollo;
    case Categoria.pavo: return localizations.categoriaPavo;
    case Categoria.vegetariano: return localizations.categoriaVegetariano;
    case Categoria.marisco: return localizations.categoriaMarisco;
    case Categoria.verdura: return localizations.categoriaVerdura;
    case Categoria.algas: return localizations.categoriaAlgas;
    case Categoria.fruta: return localizations.categoriaFruta;
    case Categoria.lacteo: return localizations.categoriaLacteo;
    case Categoria.pescado: return localizations.categoriaPescado;
    case Categoria.conservas: return localizations.categoriaConservas;
    case Categoria.legumbres: return localizations.categoriaLegumbres;
    case Categoria.bebidas: return localizations.categoriaBebidas;
    case Categoria.cereales: return localizations.categoriaCereales;
    case Categoria.secos: return localizations.categoriaSecos;
    case Categoria.bayas: return localizations.categoriaBayas;
    case Categoria.otros: return localizations.categoriaOtros;
    case Categoria.cordero: return localizations.categoriaCordero;
    case Categoria.pato: return localizations.categoriaPato;
    case Categoria.conejo: return localizations.categoriaConejo;
  }
}
final Map<Categoria, int> categoriaOrder = {
Categoria.cereales: 1,
Categoria.bebidas:   2,
Categoria.lacteo:    3,
Categoria.queso:     4,
Categoria.huevos:    5,
Categoria.fruta:     6,
Categoria.bayas:     7,
Categoria.verdura:   8,
Categoria.vegetariano: 9,
Categoria.legumbres: 10,
Categoria.algas:     11,
Categoria.pasta:     12,
Categoria.cerdo:     13,
Categoria.pollo:     14,
Categoria.pavo:      15,
Categoria.ternera:   16,
Categoria.conejo:    17,
Categoria.cordero:   18,
Categoria.pato:      19,
Categoria.pescado:   20,
Categoria.marisco:   21,
Categoria.conservas: 22,
Categoria.secos:     23,
Categoria.otros:     24,
};

class DynamicDishCalculatorScreen extends StatefulWidget {
  const DynamicDishCalculatorScreen({super.key});

  @override
  DynamicDishCalculatorScreenState createState() =>
      DynamicDishCalculatorScreenState();
}

class DynamicDishCalculatorScreenState
    extends State<DynamicDishCalculatorScreen> {
  final TextEditingController _caloriesController = TextEditingController();
  double? _enteredCalories;
  Ingredient? selectedMain;
  Ingredient? selectedSide1;
  Ingredient? selectedSide2;
  Ingredient? selectedSide3;
  List<Ingredient> mainIngredients = [];
  List<Ingredient> sideIngredients = [];
  bool _ingredientsInitialized = false;
  double _mainPercentage = 70;
  double _side1Percentage = 10;
  double _side2Percentage = 10;
  double _side3Percentage = 10;
  bool _enableSide1 = false;
  bool _enableSide2 = false;
  bool _enableSide3 = false;
  int _generateDishClickCount = 0;
  final InterstitialAdManager _adManager = InterstitialAdManager();
  bool _dontShowInfoAgain = false;
  String _monthlyPlanPrice = '2,99 €'; 

  @override
  void initState() {
    super.initState();
    _adManager.loadAd();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInfoDialogIfNeeded();
    });
  }

  @override
  void dispose() {
    _adManager.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  Future<void> _showInfoDialogIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    bool hideInfo = prefs.getBool('hideDynamicDishInfo') ?? false;
    if (!hideInfo) {
      final loc = AppLocalizations.of(context)!;
      bool dontShow = false;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            loc.dynamicDishCalculatorInfoTitle,
            style: const TextStyle(color: Colors.white),
          ),
          content: StatefulBuilder(
            builder: (ctx2, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  loc.dynamicDishCalculatorInfoMessage,
                  style: const TextStyle(color: Colors.white),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: dontShow,
                      onChanged: (v) => setState(() => dontShow = v!),
                      activeColor: const Color(0xFFF44336),
                      checkColor: Colors.white,
                    ),
                    Expanded(
                      child: Text(
                        loc.dynamicDishCalculatorInfoDontShowAgain,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _dontShowInfoAgain = dontShow;
                Navigator.of(ctx).pop();
              },
              child: Text(loc.okButton,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
      if (_dontShowInfoAgain) {
        prefs.setBool('hideDynamicDishInfo', true);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_ingredientsInitialized) {
      mainIngredients = getMainIngredients(context, "default");
      sideIngredients = getSideIngredients(context, "default");
      if (mainIngredients.isNotEmpty) selectedMain = mainIngredients[0];
      if (sideIngredients.isNotEmpty) {
        selectedSide1 = sideIngredients[0];
        selectedSide2 = sideIngredients.length > 1
            ? sideIngredients[1]
            : sideIngredients[0];
        selectedSide3 = sideIngredients.length > 2
            ? sideIngredients[2]
            : sideIngredients[0];
      }
      _ingredientsInitialized = true;
    }
  }

  Future<Ingredient?> _selectIngredient(
      List<Ingredient> ingredients, String title, BuildContext ctx) {
    final loc = AppLocalizations.of(ctx)!;
    String query = '';
    return showModalBottomSheet<Ingredient>(
      context: ctx,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx2, setState) {
          final filtered = query.isEmpty
              ? ingredients
              : ingredients
                  .where((i) =>
                      i.name.toLowerCase().contains(query.toLowerCase()))
                  .toList();
          final grouped =
              groupBy(filtered, (Ingredient i) => i.categoria);
          final sortedCats = grouped.keys.toList()
            ..sort((a, b) => categoriaOrder[a]!
                .compareTo(categoriaOrder[b]!));
          return Scaffold(
            appBar:
                AppBar(backgroundColor: Colors.black, elevation: 0),
            backgroundColor: Colors.black,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: loc.searchHint,
                      hintStyle:
                          const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                    ),
                    onChanged: (v) => setState(() => query = v),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: sortedCats
                        .map((cat) => Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: Colors.red,
                                  padding:
                                      const EdgeInsets.all(8),
                                  child: Text(
                                    getCategoriaText(
                                            cat, loc)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                ...grouped[cat]!.map((ing) =>
                                    ListTile(
                                      title: Text(ing.name,
                                          style: const TextStyle(
                                              color:
                                                  Colors.white)),
                                      subtitle: Text(
                                          '${ing.caloriesPer100g} kcal/100g, ${ing.proteinPer100g} g prot/100g',
                                          style:
                                              const TextStyle(
                                                  color: Colors
                                                      .white70,
                                                  fontSize: 12)),
                                      onTap: () =>
                                          Navigator.pop(
                                              ctx2, ing),
                                    )),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainSelector() {
    final loc = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () async {
        final ing = await _selectIngredient(
            mainIngredients,
            loc.mainIngredientLabel,
            context);
        if (ing != null) setState(() => selectedMain = ing);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: loc.mainIngredientLabel,
          filled: true,
          fillColor: Colors.black,
          labelStyle: const TextStyle(color: Colors.white),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          selectedMain?.name ?? loc.mainIngredientLabel,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSideSelector(
      String label, Ingredient? sel, bool on, int idx) {
    final loc = AppLocalizations.of(context)!;
    if (!on) return const SizedBox();
    return InkWell(
      onTap: () async {
        final ing =
            await _selectIngredient(sideIngredients, label, context);
        if (ing != null) {
          setState(() {
            if (idx == 1) selectedSide1 = ing;
            if (idx == 2) selectedSide2 = ing;
            if (idx == 3) selectedSide3 = ing;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.black,
          labelStyle: const TextStyle(color: Colors.white),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          (idx == 1
                  ? selectedSide1
                  : idx == 2
                      ? selectedSide2
                      : selectedSide3)
              ?.name ??
              label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDishDetail(
      String name, int g, int c, double p) {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Text(loc.dishDetailName(name, g.toString()),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(loc.dishDetail(c.toString(), p.toStringAsFixed(1)),
              style: const TextStyle(
                  color: Color(0xFFF44336), fontSize: 14)),
        ],
      ),
    );
  }
  void _generateDish(bool isSubscribed) {
    if (selectedMain == null ||
        _enteredCalories == null ||
        _enteredCalories! <= 0) return;
    final totalPct = _mainPercentage +
        (_enableSide1 ? _side1Percentage : 0) +
        (_enableSide2 ? _side2Percentage : 0) +
        (_enableSide3 ? _side3Percentage : 0);
    if (totalPct <= 0) return;
    final calc = (pct) => _enteredCalories! * (pct / totalPct);
    final mCal = calc(_mainPercentage);
    final s1 = _enableSide1 ? calc(_side1Percentage) : 0;
    final s2 = _enableSide2 ? calc(_side2Percentage) : 0;
    final s3 = _enableSide3 ? calc(_side3Percentage) : 0;
    final mGr = ((mCal * 100) / selectedMain!.caloriesPer100g).round();
    final cm = ((mGr * selectedMain!.caloriesPer100g) / 100).round();
    final mp = (mGr / 100) * selectedMain!.proteinPer100g;
    int s1Gr = 0, s2Gr = 0, s3Gr = 0;
    int cs1 = 0, cs2 = 0, cs3 = 0;
    double p1 = 0, p2 = 0, p3 = 0;
    if (_enableSide1 && selectedSide1 != null) {
      s1Gr = ((s1 * 100) / selectedSide1!.caloriesPer100g).round();
      cs1 = ((s1Gr * selectedSide1!.caloriesPer100g) / 100).round();
      p1 = (s1Gr / 100) * selectedSide1!.proteinPer100g;
    }
    if (_enableSide2 && selectedSide2 != null) {
      s2Gr = ((s2 * 100) / selectedSide2!.caloriesPer100g).round();
      cs2 = ((s2Gr * selectedSide2!.caloriesPer100g) / 100).round();
      p2 = (s2Gr / 100) * selectedSide2!.proteinPer100g;
    }
    if (_enableSide3 && selectedSide3 != null) {
      s3Gr = ((s3 * 100) / selectedSide3!.caloriesPer100g).round();
      cs3 = ((s3Gr * selectedSide3!.caloriesPer100g) / 100).round();
      p3 = (s3Gr / 100) * selectedSide3!.proteinPer100g;
    }
    final totC = cm + cs1 + cs2 + cs3;
    final totP = mp + p1 + p2 + p3;
    _generateDishClickCount++;

    void _showResult() {
      final loc = AppLocalizations.of(context)!;
      showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(loc.yourDish,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Divider(color: Colors.black, thickness: 1.5, height: 20),
                  _buildDishDetail(selectedMain!.name, mGr, cm, mp),
                  if (_enableSide1) _buildDishDetail(selectedSide1!.name, s1Gr, cs1, p1),
                  if (_enableSide2) _buildDishDetail(selectedSide2!.name, s2Gr, cs2, p2),
                  if (_enableSide3) _buildDishDetail(selectedSide3!.name, s3Gr, cs3, p3),
                  const SizedBox(height: 16),
                  Text(loc.totalCalories(totC.toString()),
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(loc.totalProteins(totP.toStringAsFixed(1)),
                      style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFFF44336),
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            loc.okButton,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('usuarios')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (ctx, snap) {
                            bool isSub = false;
                            String price = _monthlyPlanPrice;
                            if (snap.hasData && snap.data!.exists) {
                              final data = snap.data!.data()! as Map<String, dynamic>;
                              isSub = data['suscribed'] as bool? ?? false;
                              price = data['subscriptionProductPrice'] as String? ?? price;
                            }
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSub ? Colors.black : Colors.black38,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: isSub
                                  ? () async {
                                      final uid = FirebaseAuth.instance.currentUser!.uid;
                                      final doc = FirebaseFirestore.instance
                                          .collection('usuarios')
                                          .doc(uid)
                                          .collection('savedMeals')
                                          .doc();
                                      final name = '${selectedMain!.name}'
                                          '${_enableSide1 ? ' + ${selectedSide1!.name}' : ''}'
                                          '${_enableSide2 ? ' + ${selectedSide2!.name}' : ''}'
                                          '${_enableSide3 ? ' + ${selectedSide3!.name}' : ''}';
                                      final meal = meal_model.CustomMeal(
                                        id: doc.id,
                                        name: name,
                                        main: selectedMain!,
                                        mainGrams: mGr,
                                        side1: _enableSide1 ? selectedSide1! : null,
                                        side1Grams: _enableSide1 ? s1Gr : null,
                                        side2: _enableSide2 ? selectedSide2! : null,
                                        side2Grams: _enableSide2 ? s2Gr : null,
                                        side3: _enableSide3 ? selectedSide3! : null,
                                        side3Grams: _enableSide3 ? s3Gr : null,
                                      );
                                      try {
                                        await doc.set(meal.toJson());
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(content: Text(loc.mealSaved)));
                                      } catch (e) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(loc.errorSavingMeal(e.toString()))));
                                      }
                                    }
                                  : null,
                              child: Text(
                                loc.saveButton,
                                style: TextStyle(
                                  color: isSub ? Colors.white : Colors.white54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    if (_generateDishClickCount % 3 == 1) {
      _adManager.showAd(context);
      Future.delayed(
          const Duration(milliseconds: 500), _showResult);
    } else {
      _showResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final subStream = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .snapshots();
    final totalPct = _mainPercentage +
        (_enableSide1 ? _side1Percentage : 0) +
        (_enableSide2 ? _side2Percentage : 0) +
        (_enableSide3 ? _side3Percentage : 0);
    final valid = totalPct <= 100 &&
        _enteredCalories != null &&
        _enteredCalories! > 0;
    return StreamBuilder<DocumentSnapshot>(
      stream: subStream,
      builder: (ctx, snap) {
      bool isSub = false;
      if (snap.hasData && snap.data!.exists) {
        final data = snap.data!.data()! as Map<String, dynamic>;
        isSub = data['suscribed'] as bool? ?? false;
        _monthlyPlanPrice = data['subscriptionProductPrice'] as String? ?? _monthlyPlanPrice;
      }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            centerTitle: true,
            title: Text(loc.dynamicDishCalculatorTitle,
                style: const TextStyle(color: Colors.white)),
          ),
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: BannerAdWidget()),
                const SizedBox(height: 20),
                Text(loc.dynamicDishCalculatorPlateCalories,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                TextField(
                  controller: _caloriesController,
                  decoration: InputDecoration(
                    labelText:
                        loc.dynamicDishCalculatorInputLabel,
                    labelStyle:
                        const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => setState(
                      () => _enteredCalories = double.tryParse(v)),
                ),
                const SizedBox(height: 20),
                _buildMainSelector(),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: Text(loc.sideDish1Label,
                      style: const TextStyle(color: Colors.red)),
                  value: _enableSide1,
                  onChanged: (v) => setState(() => _enableSide1 = v),
                  activeColor: const Color(0xFFF44336),
                ),
                _buildSideSelector(
                    loc.sideDish1Label, selectedSide1, _enableSide1, 1),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: Text(loc.sideDish2Label,
                      style: const TextStyle(color: Colors.red)),
                  value: _enableSide2,
                  onChanged: (v) => setState(() => _enableSide2 = v),
                  activeColor: const Color(0xFFF44336),
                ),
                _buildSideSelector(
                    loc.sideDish2Label, selectedSide2, _enableSide2, 2),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: Text(loc.sideDish3Label,
                      style: const TextStyle(color: Colors.red)),
                  value: _enableSide3,
                  onChanged: (v) => setState(() => _enableSide3 = v),
                  activeColor: const Color(0xFFF44336),
                ),
                _buildSideSelector(
                    loc.sideDish3Label, selectedSide3, _enableSide3, 3),
                const SizedBox(height: 20),
                Text(loc.adjustPercentageLabel,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center),
                const SizedBox(height: 10),
                _buildSlider(
                    loc.mainIngredientLabel,
                    _mainPercentage,
                    (v) => setState(() => _mainPercentage = v)),
                if (_enableSide1)
                  _buildSlider(
                      loc.sideDish1Label,
                      _side1Percentage,
                      (v) => setState(() => _side1Percentage = v)),
                if (_enableSide2)
                  _buildSlider(
                      loc.sideDish2Label,
                      _side2Percentage,
                      (v) => setState(() => _side2Percentage = v)),
                if (_enableSide3)
                  _buildSlider(
                      loc.sideDish3Label,
                      _side3Percentage,
                      (v) => setState(() => _side3Percentage = v)),
                const SizedBox(height: 10),
                Text(
                  loc.dynamicDishCalculatorTotalPercentage(
                      (totalPct > 100).toString(), totalPct.toInt().toString()),
                  style: TextStyle(
                      color:
                          totalPct > 100 ? Colors.red : Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: valid ? () => _generateDish(isSub) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 28),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    loc.dynamicDishCalculatorButton,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSlider(
      String label, double value, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white)),
            Text("${value.toInt()}%",
                style: const TextStyle(color: Colors.white))
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 100,
          label: value.toStringAsFixed(0),
          onChanged: onChanged,
          activeColor: const Color(0xFFF44336),
          inactiveColor: Colors.white24,
        ),
      ],
    );
  }
}