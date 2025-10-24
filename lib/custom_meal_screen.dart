import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';
import 'widgets/banner_ad_widget.dart';
import 'widgets/interstitial_ad_manager.dart';
import 'package:nuevo_proyecto/models/custom_meal.dart' as meal_model;
import 'package:nuevo_proyecto/models/ingredient.dart' show Ingredient, Categoria;
import 'package:nuevo_proyecto/services/firestore_saved_meals_service.dart' as saved_meals_service;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Ingredient> getMainIngredients(BuildContext context, String mealType) {
  switch (mealType) {
    case 'desayuno':
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
    case 'almuerzo':
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
case 'merienda':
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
case 'cena':
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
    default:
      return [];
  }
}
List<Ingredient> getSideIngredients(BuildContext context, String mealType) {
  switch (mealType) {
    case 'desayuno':
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
    case 'almuerzo':
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
    case 'merienda':
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
    case 'cena':
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
    default:
      return [];
  }
}

class CustomMealScreen extends StatefulWidget {
  final String mealType;
  final int mealCalories;
  const CustomMealScreen({
    super.key,
    required this.mealType,
    required this.mealCalories,
  });
  @override
  CustomMealScreenState createState() => CustomMealScreenState();
}

class CustomMealScreenState extends State<CustomMealScreen> {
  Ingredient? selectedMain;
  Ingredient? selectedSide1;
  Ingredient? selectedSide2;

  late List<Ingredient> mainIngredients;
  late List<Ingredient> sideIngredients;
  bool _ingredientsInitialized = false;
  bool _enableSide1 = false;
  bool _enableSide2 = false;
  int _generateDishClickCount = 0;
  final InterstitialAdManager _adManager = InterstitialAdManager();

  late int mainGrams;
  late int side1Grams;
  late int side2Grams;
  late int calcMainCalories;
  late int calcSide1Calories;
  late int calcSide2Calories;
  late double mainProtein;
  late double side1Protein;
  late double side2Protein;

  @override
  void initState() {
    super.initState();
    _adManager.loadAd();
  }

  @override
  void dispose() {
    _adManager.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_ingredientsInitialized) {
      mainIngredients = getMainIngredients(context, widget.mealType);
      sideIngredients = getSideIngredients(context, widget.mealType);
      if (mainIngredients.isNotEmpty) selectedMain = mainIngredients[0];
      if (sideIngredients.isNotEmpty) {
        selectedSide1 = sideIngredients[0];
        selectedSide2 = sideIngredients.length > 1
            ? sideIngredients[1]
            : sideIngredients[0];
      }
      _ingredientsInitialized = true;
    }
  }

Future<Ingredient?> _selectIngredient(
  List<Ingredient> ingredients,
  String title,
  BuildContext context,
) async {
  final localizations = AppLocalizations.of(context)!;
  const Map<Categoria, int> categoriaOrder = {
    Categoria.cereales:      1,
    Categoria.bebidas:       2,
    Categoria.lacteo:        3,
    Categoria.queso:         4,
    Categoria.huevos:        5,
    Categoria.fruta:         6,
    Categoria.bayas:         7,
    Categoria.verdura:       8,
    Categoria.vegetariano:   9,
    Categoria.legumbres:    10,
    Categoria.algas:        11,
    Categoria.pasta:        12,
    Categoria.cerdo:        13,
    Categoria.pollo:        14,
    Categoria.pavo:         15,
    Categoria.ternera:      16,
    Categoria.conejo:       17,
    Categoria.cordero:      18,
    Categoria.pato:         19,
    Categoria.pescado:      20,
    Categoria.marisco:      21,
    Categoria.conservas:    22,
    Categoria.secos:        23,
    Categoria.otros:        24,
  };

  String query = '';
  return showModalBottomSheet<Ingredient>(
    context: context,
    backgroundColor: Colors.black,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => SafeArea(
      child: StatefulBuilder(
        builder: (ctx2, setState) {
          final filtered = query.isEmpty
              ? ingredients
              : ingredients
                  .where((ing) =>
                      ing.name.toLowerCase().contains(query.toLowerCase()))
                  .toList();
          final rawMap =
              groupBy(filtered, (Ingredient ing) => ing.categoria);
          final orderedCats = rawMap.keys.toList()
            ..sort((a, b) =>
                categoriaOrder[a]!.compareTo(categoriaOrder[b]!));

          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: localizations.searchHint,
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (v) => setState(() => query = v),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      for (final cat in orderedCats) ...[
                        Container(
                          width: double.infinity,
                          color: Colors.red,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Ingredient.getCategoriaText(cat, localizations)
                                .toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        for (final ing
                            in (rawMap[cat]!..sort((a, b) => a.name.compareTo(b.name))))
                          ListTile(
                            title: Text(
                              ing.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              '${ing.caloriesPer100g} kcal/100g, ${ing.proteinPer100g} g prot/100g',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            onTap: () => Navigator.pop(context, ing),
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

  Widget _buildCustomSelector(String label, Ingredient? selected,
      List<Ingredient> ingredients, void Function(Ingredient?) onChanged) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.78,
      child: InkWell(
        onTap: () async {
          final ing = await _selectIngredient(ingredients, label, context);
          if (ing != null) onChanged(ing);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.black,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            labelStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 233, 54, 54)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            selected?.name ?? label,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _generateDish(bool subscribed, String monthlyPrice) {
    if (selectedMain == null) return;
    _generateDishClickCount++;
    final baseMain = 0.65;
    final base1 = _enableSide1 ? 0.25 : 0.0;
    final base2 = _enableSide2 ? 0.10 : 0.0;
    final totalBase = baseMain + base1 + base2;
    final effMain = baseMain / totalBase;
    final eff1 = base1 / totalBase;
    final eff2 = base2 / totalBase;
    final mc = widget.mealCalories * effMain;
    final c1 = widget.mealCalories * eff1;
    final c2 = widget.mealCalories * eff2;

    mainGrams = ((mc * 100) / selectedMain!.caloriesPer100g).round();
    side1Grams = _enableSide1
        ? ((c1 * 100) / selectedSide1!.caloriesPer100g).round()
        : 0;
    side2Grams = _enableSide2
        ? ((c2 * 100) / selectedSide2!.caloriesPer100g).round()
        : 0;
    calcMainCalories =
        ((mainGrams * selectedMain!.caloriesPer100g) / 100).round();
    calcSide1Calories = _enableSide1
        ? ((side1Grams * selectedSide1!.caloriesPer100g) / 100).round()
        : 0;
    calcSide2Calories = _enableSide2
        ? ((side2Grams * selectedSide2!.caloriesPer100g) / 100).round()
        : 0;
    mainProtein = (mainGrams / 100.0) * selectedMain!.proteinPer100g;
    side1Protein = _enableSide1
        ? (side1Grams / 100.0) * selectedSide1!.proteinPer100g
        : 0;
    side2Protein = _enableSide2
        ? (side2Grams / 100.0) * selectedSide2!.proteinPer100g
        : 0;
    if (_generateDishClickCount % 3 == 1) {
      _adManager.showAd(context);
      Future.delayed(const Duration(milliseconds: 500),
          () => _showDish(subscribed, monthlyPrice));
    } else {
      _showDish(subscribed, monthlyPrice);
    }
  }

  void _showDish(bool subscribed, String monthlyPrice) {
    final loc = AppLocalizations.of(context)!;
    final totalCalories = calcMainCalories + calcSide1Calories + calcSide2Calories;
    final totalProtein = mainProtein + side1Protein + side2Protein;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.yourDish,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Divider(color: Colors.black, thickness: 1.5, height: 20),
              _buildDishDetail(
                context,
                selectedMain!.name,
                mainGrams,
                calcMainCalories,
                mainProtein,
              ),
              if (_enableSide1)
                _buildDishDetail(
                  context,
                  selectedSide1!.name,
                  side1Grams,
                  calcSide1Calories,
                  side1Protein,
                ),
              if (_enableSide2)
                _buildDishDetail(
                  context,
                  selectedSide2!.name,
                  side2Grams,
                  calcSide2Calories,
                  side2Protein,
                ),
              const SizedBox(height: 16),
              Text(
                loc.totalCalories(totalCalories.toString()),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                loc.totalProteins(totalProtein.toStringAsFixed(1)),
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFFF44336),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        loc.okButton,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: subscribed ? Colors.black : Colors.black38,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: subscribed ? _saveMeal : null,
                      child: Text(
                        loc.saveButton,
                        style: TextStyle(
                          color: subscribed ? Colors.white : Colors.white54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveMeal() async {
    final loc = AppLocalizations.of(context)!;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = FirebaseFirestore.instance
        .collection('usuarios')         
        .doc(uid)
        .collection('savedMeals')
        .doc();
    final autoName =
        '${selectedMain!.name}'
        '${_enableSide1 ? ' + ${selectedSide1!.name}' : ''}'
        '${_enableSide2 ? ' + ${selectedSide2!.name}' : ''}';
    final toSave = meal_model.CustomMeal(
      id: docRef.id,
      name: autoName,
      main: selectedMain!,
      mainGrams: mainGrams,
      side1: _enableSide1 ? selectedSide1! : null,
      side1Grams: _enableSide1 ? side1Grams : null,
      side2: _enableSide2 ? selectedSide2! : null,
      side2Grams: _enableSide2 ? side2Grams : null,
    );
    try {
      await docRef.set(toSave.toJson());
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.mealSaved)),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.errorSavingMeal(e.toString()))),
      );
    }
  }

  Widget _buildDishDetail(
      BuildContext c, String name, int grams, int calories, double protein) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        children: [
          Text('$name - $grams g',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const SizedBox(height: 4),
          Text('$calories kcal, ${protein.toStringAsFixed(1)} g prot',
              style: const TextStyle(fontSize: 14, color: Colors.black)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final subscriptionStream = FirebaseFirestore.instance
      .collection('usuarios')
      .doc(uid)
      .snapshots();
    double mainPerc, side1Perc, side2Perc;
    if (_enableSide1 && _enableSide2) {
      mainPerc = 65;
      side1Perc = 25;
      side2Perc = 10;
    } else if (_enableSide1) {
      mainPerc = 65;
      side1Perc = 35;
      side2Perc = 0;
    } else if (_enableSide2) {
      mainPerc = 65;
      side1Perc = 0;
      side2Perc = 35;
    } else {
      mainPerc = 100;
      side1Perc = 0;
      side2Perc = 0;
    }
    return StreamBuilder<DocumentSnapshot>(
      stream: subscriptionStream,
      builder: (context, subSnap) {
        bool subscribed = false;
        String monthlyPrice = '—';
        if (subSnap.hasData && subSnap.data!.exists) {
          final data = subSnap.data!.data()! as Map<String, dynamic>;
          subscribed = data['suscribed'] as bool? ?? false;
          monthlyPrice = data['subscriptionProductPrice'] as String? ?? monthlyPrice;
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          backgroundColor: Colors.black,
            body: Column(
              children: [
                const BannerAdWidget(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 64), 
                    child: Column(
                      children: [
                      Lottie.asset(
                        'assets/animations/select-food.json',
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!
                            .customMealInfo(widget.mealCalories.toString()),
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      _buildCustomSelector(
                        AppLocalizations.of(context)!.mainIngredientLabel,
                        selectedMain,
                        mainIngredients,
                        (ing) => setState(() => selectedMain = ing),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.mainIngredientInfo(
                            mainPerc.toInt().toString()),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      const SizedBox(height: 13),
                      SwitchListTile(
                        title: Text(
                          AppLocalizations.of(context)!.sideDish1Label,
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        value: _enableSide1,
                        onChanged: (v) =>
                            setState(() => _enableSide1 = v),
                        activeColor:
                            const Color.fromARGB(255, 244, 67, 54),
                      ),
                      if (_enableSide1)
                        _buildCustomSelector(
                          AppLocalizations.of(context)!.sideDish1Label,
                          selectedSide1,
                          sideIngredients,
                          (ing) => setState(() => selectedSide1 = ing),
                        ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!
                            .sideDish1Info(side1Perc.toInt().toString()),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      const SizedBox(height: 13),
                      SwitchListTile(
                        title: Text(
                          AppLocalizations.of(context)!.sideDish2Label,
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        value: _enableSide2,
                        onChanged: (v) =>
                            setState(() => _enableSide2 = v),
                        activeColor:
                            const Color.fromARGB(255, 244, 67, 54),
                      ),
                      if (_enableSide2)
                        _buildCustomSelector(
                          AppLocalizations.of(context)!.sideDish2Label,
                          selectedSide2,
                          sideIngredients,
                          (ing) => setState(() => selectedSide2 = ing),
                        ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!
                            .sideDish2Info(side2Perc.toInt().toString()),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () =>
                            _generateDish(subscribed, monthlyPrice),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 244, 67, 54),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 28),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.generateDishButton,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,      
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}