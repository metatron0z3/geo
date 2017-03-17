<?php

namespace AppBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Bundle\FrameworkBundle\Templating\TemplateReference;
use Symfony\Component\Routing\Exception\ResourceNotFoundException;
use Symfony\Component\Validator\Validator\ValidatorInterface;
use AppBundle\Entity\Airports;
use FOS\RestBundle\View\View;
use FOS\RestBundle\View\ViewHandler;
use JMS\Serializer\SerializationContext;

class GeoController extends Controller
{
    /**
     * @Route("/api/geo", name="geo")
     * @Method("POST")
     */
    public function getClosestAirportsAction($country1, $country2)
    {

        $query = $em->createQuery('SELECT get_closest_airports($country1, $country2)');
        $result = $query->getResult();


        return new JsonResponse([
            'success' => true,
            'result'    => $result
        ]);
    }
}
