using Application.Interfaces.PersonDelete;
using Microsoft.AspNetCore.Mvc;

namespace Barber_API.Controllers
{

    [ApiController]
    [Route("api/persons/delete")]
    public class PersonDeleteController: ControllerBase
    {
    private readonly IPersonDeleteBLL _service;

    public PersonDeleteController(IPersonDeleteBLL service)
    {
        _service = service;
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        var result = await _service.DeleteAsync(id);

        if (!result)
            return NotFound(new
            {
                success = false,
                message = "Persona no encontrada o ya eliminada"
            });

        return Ok(new { success = true });
    }

}
}
